import localforage from 'localforage';

localforage.config({
  name: 'ArLABSFinance',
  storeName: 'offline_cache'
});

export const OfflineStore = {
  async set<T>(key: string, value: T): Promise<void> {
    try {
      await localforage.setItem(key, value);
    } catch (e) {
      console.error('OfflineStore error saving key:', key, e);
    }
  },

  async get<T>(key: string): Promise<T | null> {
    try {
      return await localforage.getItem<T>(key);
    } catch (e) {
      console.error('OfflineStore error getting key:', key, e);
      return null;
    }
  },

  async remove(key: string): Promise<void> {
    try {
      await localforage.removeItem(key);
    } catch (e) {
      console.error('OfflineStore error removing key:', key, e);
    }
  },

  async clear(): Promise<void> {
    await localforage.clear();
  }
};
