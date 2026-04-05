const fs = require('fs');
const path = require('path');
const admin = require('../functions/node_modules/firebase-admin');
const { GoogleAuth } = require('../functions/node_modules/google-auth-library');

// Firebase CLI 토큰 가져오기
const configPath = path.join(process.env.HOME, '.config/configstore/firebase-tools.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const refreshToken = config.tokens.refresh_token;
const clientId = config.tokens.client_id || '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com';
const clientSecret = config.tokens.client_secret || 'j9iVZfS8kkCEFUPaAeJV0sAi';

// Application Default Credentials 파일 생성
const adcPath = '/tmp/firebase_adc.json';
fs.writeFileSync(adcPath, JSON.stringify({
  type: 'authorized_user',
  client_id: clientId,
  client_secret: clientSecret,
  refresh_token: refreshToken,
}));
process.env.GOOGLE_APPLICATION_CREDENTIALS = adcPath;

admin.initializeApp({ projectId: 'linkping-prod' });
const db = admin.firestore();

// 더미 유저 프로필들
const dummyUsers = [
  { uid: 'dummy_01', nickname: 'Wandering April Tiger', profileEmoji: 'face_grinning', country: 'US' },
  { uid: 'dummy_02', nickname: 'Dreamy June Owl', profileEmoji: 'face_heart_eyes', country: 'GB' },
  { uid: 'dummy_03', nickname: 'Silent March Fox', profileEmoji: 'face_sunglasses', country: 'JP' },
  { uid: 'dummy_04', nickname: 'Golden Autumn Deer', profileEmoji: 'face_star_struck', country: 'KR' },
  { uid: 'dummy_05', nickname: 'Crystal Winter Cat', profileEmoji: 'face_winking', country: 'DE' },
  { uid: 'dummy_06', nickname: 'Velvet Spring Lily', profileEmoji: 'face_smiling', country: 'FR' },
  { uid: 'dummy_07', nickname: 'Sparkling May Firefly', profileEmoji: 'face_zany', country: 'AU' },
  { uid: 'dummy_08', nickname: 'Midnight July Wolf', profileEmoji: 'face_cowboy', country: 'CA' },
  { uid: 'dummy_09', nickname: 'Gentle Dawn Rabbit', profileEmoji: 'face_nerd', country: 'BR' },
  { uid: 'dummy_10', nickname: 'Misty October Cloud', profileEmoji: 'face_partying', country: 'ES' },
  { uid: 'dummy_11', nickname: 'Curious Summer Breeze', profileEmoji: 'face_monocle', country: 'IT' },
  { uid: 'dummy_12', nickname: 'Floating Snow Cherry', profileEmoji: 'face_pleading', country: 'NL' },
  { uid: 'dummy_13', nickname: 'Lazy Twilight Maple', profileEmoji: 'face_relieved', country: 'SE' },
  { uid: 'dummy_14', nickname: 'Dancing Rain Willow', profileEmoji: 'face_yum', country: 'NZ' },
  { uid: 'dummy_15', nickname: 'Whispering Moon Dew', profileEmoji: 'face_innocent', country: 'SG' },
];

// 링크 데이터
const dummyLinks = [
  { title: 'Morning Yoga Routine', url: 'https://youtube.com/yoga-morning' },
  { title: 'Daily English Practice', url: 'https://duolingo.com' },
  { title: 'Read 10 Pages', url: 'https://kindle.amazon.com' },
  { title: 'Check Portfolio', url: 'https://robinhood.com' },
  { title: 'Meditation 15min', url: 'https://headspace.com' },
  { title: 'Call Mom', url: 'tel:+11234567890' },
  { title: 'Weekly Meal Prep', url: 'https://pinterest.com/meal-prep' },
  { title: 'Side Project Todo', url: 'https://notion.so/my-project' },
  { title: 'Stretch & Walk', url: 'https://youtube.com/stretch-walk' },
  { title: 'Journal Writing', url: 'https://docs.google.com/journal' },
];

// Dart hashCode 호환 URL 해시
function dartHashCode(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash + str.charCodeAt(i)) & 0xFFFFFFFF;
  }
  // Dart는 signed 32-bit, JS로 재현
  if (hash > 0x7FFFFFFF) hash -= 0x100000000;
  return Math.abs(hash).toString(16);
}

function pickRandomUsers(count) {
  const shuffled = [...dummyUsers].sort(() => Math.random() - 0.5);
  return shuffled.slice(0, Math.min(count, dummyUsers.length));
}

async function seedData() {
  console.log('Seeding dummy data to Firestore...\n');

  const batch = db.batch();

  const saveCounts = {
    'Morning Yoga Routine': 175,
    'Daily English Practice': 89,
    'Meditation 15min': 42,
    'Read 10 Pages': 13,
    'Weekly Meal Prep': 11,
    'Stretch & Walk': 9,
    'Check Portfolio': 8,
    'Side Project Todo': 7,
    'Call Mom': 6,
    'Journal Writing': 5,
  };

  for (const link of dummyLinks) {
    const urlHash = dartHashCode(link.url);
    const saveCount = saveCounts[link.title] || 5;
    const savedBy = pickRandomUsers(saveCount);

    const docRef = db.collection('urlStats').doc(urlHash);
    batch.set(docRef, {
      saveCount: saveCount,
      savedBy: savedBy,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    console.log(`  ${link.title}: ${saveCount} saves (hash: ${urlHash})`);
  }

  await batch.commit();
  console.log('\nDummy data seeded successfully!');

  // cleanup
  fs.unlinkSync(adcPath);
  process.exit(0);
}

seedData().catch(err => {
  console.error('Error:', err);
  try { fs.unlinkSync(adcPath); } catch(_) {}
  process.exit(1);
});
