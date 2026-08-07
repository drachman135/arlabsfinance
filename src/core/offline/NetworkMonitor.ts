import { Network } from '@capacitor/network';
import type { ConnectionStatus } from '@capacitor/network';

type NetworkCallback = (status: ConnectionStatus) => void;

class NetworkMonitorService {
  private status: ConnectionStatus = { connected: true, connectionType: 'unknown' };
  private listeners: NetworkCallback[] = [];

  constructor() {
    this.init();
  }

  private async init() {
    this.status = await Network.getStatus();
    
    Network.addListener('networkStatusChange', (status) => {
      console.log('Network status changed', status);
      this.status = status;
      this.listeners.forEach(fn => fn(status));
    });
  }

  public getStatus(): ConnectionStatus {
    return this.status;
  }

  public isOnline(): boolean {
    return this.status.connected;
  }

  public addListener(callback: NetworkCallback) {
    this.listeners.push(callback);
    // return unsubscribe function
    return () => {
      this.listeners = this.listeners.filter(l => l !== callback);
    };
  }
}

export const NetworkMonitor = new NetworkMonitorService();
