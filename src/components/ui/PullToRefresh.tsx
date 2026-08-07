import React, { useState } from 'react';
import type { ReactNode } from 'react';
import { Loader2, RefreshCw } from 'lucide-react';

interface PullToRefreshProps {
  onRefresh: () => Promise<void>;
  children: ReactNode;
}

export function PullToRefresh({ onRefresh, children }: PullToRefreshProps) {
  const [startY, setStartY] = useState(0);
  const [currentY, setCurrentY] = useState(0);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [pulling, setPulling] = useState(false);
  
  const threshold = 80;
  
  const handleTouchStart = (e: React.TouchEvent) => {
    if (window.scrollY === 0) {
      setStartY(e.touches[0].clientY);
    }
  };
  
  const handleTouchMove = (e: React.TouchEvent) => {
    if (startY > 0 && window.scrollY === 0) {
      const y = e.touches[0].clientY;
      if (y > startY) {
        setPulling(true);
        setCurrentY(y);
        // Prevent default scrolling when pulling down
        if (e.cancelable) e.preventDefault();
      }
    }
  };
  
  const handleTouchEnd = async () => {
    if (pulling) {
      const distance = currentY - startY;
      if (distance > threshold && !isRefreshing) {
        setIsRefreshing(true);
        setPulling(false);
        setStartY(0);
        setCurrentY(0);
        
        try {
          await onRefresh();
        } finally {
          setIsRefreshing(false);
        }
      } else {
        setPulling(false);
        setStartY(0);
        setCurrentY(0);
      }
    }
  };
  
  const pullDistance = Math.min(Math.max(currentY - startY, 0), threshold + 40);
  const pullPercentage = Math.min(pullDistance / threshold, 1);
  
  return (
    <div 
      className="relative w-full min-h-screen overflow-hidden"
      onTouchStart={handleTouchStart}
      onTouchMove={handleTouchMove}
      onTouchEnd={handleTouchEnd}
    >
      {/* Pull indicator */}
      <div 
        className="absolute w-full flex justify-center items-center overflow-hidden transition-all duration-200 z-50"
        style={{
          height: pulling ? `${pullDistance}px` : isRefreshing ? '60px' : '0px',
          opacity: pulling || isRefreshing ? 1 : 0
        }}
      >
        <div className="bg-white p-2 rounded-full shadow-md flex items-center justify-center text-blue-500">
          {isRefreshing ? (
            <Loader2 className="w-6 h-6 animate-spin" />
          ) : (
            <RefreshCw 
              className="w-6 h-6" 
              style={{ transform: `rotate(${pullPercentage * 180}deg)`, opacity: pullPercentage }}
            />
          )}
        </div>
      </div>
      
      {/* Content wrapper */}
      <div 
        className="w-full transition-transform duration-300"
        style={{ transform: `translateY(${isRefreshing ? 60 : pulling ? pullDistance * 0.5 : 0}px)` }}
      >
        {children}
      </div>
    </div>
  );
}
