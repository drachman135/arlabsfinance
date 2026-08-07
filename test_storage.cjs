const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const supabase = createClient(
  "https://dpthhttwmtgtbrsjtfcg.supabase.co", 
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwdGhodHR3bXRndGJyc2p0ZmNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MTA0NjUsImV4cCI6MjA5ODA4NjQ2NX0.kUHLK0QIVdCu0jAMq3zp8bxDpvg1g-9Mj5FrGoA1tB4"
);

async function testStorage() {
  console.log("Checking buckets...");
  const { data: buckets, error: bucketsError } = await supabase.storage.listBuckets();
  console.log("Buckets Error:", bucketsError);
  console.log("Buckets:", buckets ? buckets.map(b => b.name) : []);

  console.log("\nAttempting dummy upload...");
  // Create a dummy file
  const dummyContent = "dummy image data";
  const { data, error } = await supabase.storage
    .from('chat_attachments')
    .upload(`test_folder/test_${Date.now()}.txt`, dummyContent);
    
  console.log("Upload Error:", error);
  console.log("Upload Data:", data);
}

testStorage();
