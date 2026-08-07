const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  "https://dpthhttwmtgtbrsjtfcg.supabase.co", 
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwdGhodHR3bXRndGJyc2p0ZmNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MTA0NjUsImV4cCI6MjA5ODA4NjQ2NX0.kUHLK0QIVdCu0jAMq3zp8bxDpvg1g-9Mj5FrGoA1tB4"
);

async function test() {
  const { data, error } = await supabase.from('licenses').select('*');
  console.log("Licenses Error:", error);
  console.log("Licenses Data:", data);
}
test();
