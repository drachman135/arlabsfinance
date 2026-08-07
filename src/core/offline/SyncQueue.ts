import { OfflineStore } from './OfflineStore';
import { supabase } from '../supabase';

export interface SyncTask {
  id: string; // uuid
  table: string;
  action: 'INSERT' | 'UPDATE' | 'DELETE';
  payload: any;
  createdAt: number;
}

const QUEUE_KEY = 'sync_tasks_queue';

class SyncQueueService {
  private isProcessing = false;

  async enqueue(task: Omit<SyncTask, 'id' | 'createdAt'>) {
    const queue = await this.getQueue();
    const newTask: SyncTask = {
      ...task,
      id: crypto.randomUUID(),
      createdAt: Date.now()
    };
    
    queue.push(newTask);
    await OfflineStore.set(QUEUE_KEY, queue);
    console.log('[SyncQueue] Enqueued task', newTask);
  }

  async getQueue(): Promise<SyncTask[]> {
    return (await OfflineStore.get<SyncTask[]>(QUEUE_KEY)) || [];
  }

  async processQueue() {
    if (this.isProcessing) return;
    
    const queue = await this.getQueue();
    if (queue.length === 0) return;

    this.isProcessing = true;
    console.log(`[SyncQueue] Processing ${queue.length} tasks...`);

    const remainingTasks: SyncTask[] = [];

    for (const task of queue) {
      try {
        if (task.action === 'INSERT') {
          const { error } = await supabase.from(task.table).insert(task.payload);
          if (error) throw error;
        } else if (task.action === 'UPDATE') {
           // For future use
        } else if (task.action === 'DELETE') {
           // For future use
        }
        console.log(`[SyncQueue] Successfully synced task ${task.id}`);
      } catch (err) {
        console.error(`[SyncQueue] Failed to sync task ${task.id}`, err);
        // Put back in queue to try again later
        remainingTasks.push(task);
      }
    }

    await OfflineStore.set(QUEUE_KEY, remainingTasks);
    this.isProcessing = false;
  }
}

export const SyncQueue = new SyncQueueService();
