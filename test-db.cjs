const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://dpthhttwmtgtbrsjtfcg.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwdGhodHR3bXRndGJyc2p0ZmNnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MTA0NjUsImV4cCI6MjA5ODA4NjQ2NX0.kUHLK0QIVdCu0jAMq3zp8bxDpvg1g-9Mj5FrGoA1tB4'
);

async function check() {
  console.log("Checking specific license...");
  const { data: licenses } = await supabase.from('licenses').select('*').eq('license_key', 'AR-EY307-HERB1-95QRB');
  console.log(licenses);

  console.log("\nChecking kasbon_ledger for this license...");
  const { data: ledger } = await supabase.from('kasbon_ledger').select('*').eq('client_id', 'AR-EY307-HERB1-95QRB');
  console.log(ledger);

  console.log("\nChecking kasbon_ledger for owner (customer_id)...");
  if (licenses && licenses.length > 0) {
    const custId = licenses[0].customer_id;
    const { data: ledgerCust } = await supabase.from('kasbon_ledger').select('*').eq('client_id', custId);
    console.log(ledgerCust);
  }

  console.log("\nChecking license_sessions...");
  const { data: sessions } = await supabase.from('license_sessions').select('*');
  console.log(sessions);
}

check();
