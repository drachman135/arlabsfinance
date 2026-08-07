import { PushNotifications } from '@capacitor/push-notifications';
import { Capacitor } from '@capacitor/core';
import { supabase } from '../supabase';
import { LicenseService } from '../license/LicenseService';

export class PushNotificationService {
  static async initialize() {
    // Push notifications are only supported on native devices (Android/iOS)
    if (!Capacitor.isNativePlatform()) {
      console.log('Push notifications are not supported on web.');
      return;
    }

    try {
      // 1. Request Permission
      const permission = await PushNotifications.requestPermissions();
      if (permission.receive !== 'granted') {
        console.warn('Push notification permission denied');
        return;
      }

      // 2. Register with FCM
      await PushNotifications.register();

      // 3. Listen for token registration
      PushNotifications.addListener('registration', async (token) => {
        console.log('FCM Token generated:', token.value);
        await this.saveTokenToSupabase(token.value);
      });

      // Handle registration errors
      PushNotifications.addListener('registrationError', (error) => {
        console.error('Push registration error:', error);
      });

      // 4. Listen for incoming notifications in the foreground
      PushNotifications.addListener('pushNotificationReceived', (notification) => {
        console.log('Foreground Push Received:', notification);
        // You could trigger a local state update or toast here if needed
      });

      // 5. Listen for user tapping the notification
      PushNotifications.addListener('pushNotificationActionPerformed', (action) => {
        console.log('Push Action Performed:', action);
        
        const data = action.notification.data;
        if (data && data.route) {
          // Redirect to the specific route (e.g. /chat)
          window.location.href = data.route;
        }
      });

    } catch (error) {
      console.error('Error initializing Push Notifications:', error);
    }
  }

  static async saveTokenToSupabase(fcmToken: string) {
    const license = LicenseService.getLicenseLocally();
    if (!license || !license.license_key) return;

    try {
      const { error } = await supabase
        .from('licenses')
        .update({ fcm_token: fcmToken })
        .eq('license_key', license.license_key);

      if (error) {
        console.error('Failed to save FCM token to Supabase:', error);
      } else {
        console.log('FCM token saved successfully for client:', license.license_key);
      }
    } catch (err) {
      console.error('Supabase error saving FCM token:', err);
    }
  }
}
