const fs = require('fs');
const path = require('path');
const admin = require('../functions/node_modules/firebase-admin');

// Firebase CLI 토큰
const configPath = path.join(process.env.HOME, '.config/configstore/firebase-tools.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const adcPath = '/tmp/firebase_adc.json';
fs.writeFileSync(adcPath, JSON.stringify({
  type: 'authorized_user',
  client_id: config.tokens.client_id || '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com',
  client_secret: config.tokens.client_secret || 'j9iVZfS8kkCEFUPaAeJV0sAi',
  refresh_token: config.tokens.refresh_token,
}));
process.env.GOOGLE_APPLICATION_CREDENTIALS = adcPath;

admin.initializeApp({ projectId: 'linkping-prod' });
const db = admin.firestore();

// 잘못된 JS hash -> 올바른 Dart hash 매핑
const hashMap = {
  '6e63346f': '373ef515',  // Morning Yoga Routine
  '2c41b95d': '10ba7b0b',  // Daily English Practice
  '237c73d7': '3a83cef0',  // Read 10 Pages
  '1361d116': '1d0e8521',  // Check Portfolio
  '1f97d44a': '394c1cfa',  // Meditation 15min
  '4d16f180': '36775272',  // Call Mom
  '6c9f63e6': '146e9fda',  // Weekly Meal Prep
  '75088901': '156371e1',  // Side Project Todo
  '585abd67': 'e965308',   // Stretch & Walk
  '10b0e8a8': '1ca6f2d7',  // Journal Writing
};

async function fixHashes() {
  console.log('Fixing URL hashes (JS -> Dart)...\n');

  for (const [oldHash, newHash] of Object.entries(hashMap)) {
    const oldDoc = await db.collection('urlStats').doc(oldHash).get();
    if (!oldDoc.exists) {
      console.log(`  SKIP: ${oldHash} not found`);
      continue;
    }

    const data = oldDoc.data();
    // 새 해시로 복사
    await db.collection('urlStats').doc(newHash).set(data);
    // 이전 문서 삭제
    await db.collection('urlStats').doc(oldHash).delete();
    console.log(`  ${oldHash} -> ${newHash} (saves: ${data.saveCount})`);
  }

  console.log('\nAll hashes fixed!');
  fs.unlinkSync(adcPath);
  process.exit(0);
}

fixHashes().catch(err => {
  console.error('Error:', err);
  try { fs.unlinkSync(adcPath); } catch(_) {}
  process.exit(1);
});
