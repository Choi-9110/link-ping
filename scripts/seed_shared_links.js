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

// Bang-G 계정 UID를 찾아서 쓸 거임 (일단 placeholder)
// 나중에 실제 uid로 교체
const CREATOR_UID = 'bang-g-creator';
const CREATOR_NICKNAME = 'Bang-G';

// 더미 유저들
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

function pickRandomUsers(count) {
  const shuffled = [...dummyUsers].sort(() => Math.random() - 0.5);
  return shuffled.slice(0, Math.min(count, dummyUsers.length));
}

// 공유 링크 데이터
const sharedLinks = [
  { title: 'Morning Yoga Routine', url: 'https://youtube.com/yoga-morning', hour: 6, minute: 30, repeatDays: [1,2,3,4,5], saveCount: 175 },
  { title: 'Daily English Practice', url: 'https://duolingo.com', hour: 8, minute: 0, repeatDays: [0,1,2,3,4,5,6], saveCount: 89 },
  { title: 'Meditation 15min', url: 'https://headspace.com', hour: 22, minute: 0, repeatDays: [0,1,2,3,4,5,6], saveCount: 42 },
  { title: 'Read 10 Pages', url: 'https://kindle.amazon.com', hour: 21, minute: 30, repeatDays: [0,1,2,3,4,5,6], saveCount: 13 },
  { title: 'Weekly Meal Prep', url: 'https://pinterest.com/meal-prep', hour: 10, minute: 0, repeatDays: [0], saveCount: 11 },
  { title: 'Stretch & Walk', url: 'https://youtube.com/stretch-walk', hour: 15, minute: 0, repeatDays: [1,2,3,4,5], saveCount: 9 },
  { title: 'Check Portfolio', url: 'https://robinhood.com', hour: 9, minute: 0, repeatDays: [1,3,5], saveCount: 8 },
  { title: 'Side Project Todo', url: 'https://notion.so/my-project', hour: 19, minute: 0, repeatDays: [1,3,5], saveCount: 7 },
  { title: 'Call Mom', url: 'tel:+11234567890', hour: 18, minute: 0, repeatDays: [0], saveCount: 6 },
  { title: 'Journal Writing', url: 'https://docs.google.com/journal', hour: 23, minute: 0, repeatDays: [0,1,2,3,4,5,6], saveCount: 5 },
];

async function seedData() {
  console.log('Seeding shared links to Firestore...\n');

  // 먼저 Bang-G 계정의 실제 UID 찾기
  const usersSnapshot = await db.collection('users')
    .where('nickname', '==', 'Bang-G')
    .limit(1)
    .get();

  let creatorUid = CREATOR_UID;
  if (!usersSnapshot.empty) {
    creatorUid = usersSnapshot.docs[0].id;
    console.log(`  Found Bang-G uid: ${creatorUid}\n`);
  } else {
    console.log('  Bang-G not found in users collection, using placeholder\n');
  }

  const batch = db.batch();
  const createdIds = [];

  for (const link of sharedLinks) {
    const docRef = db.collection('sharedLinks').doc(); // auto-generated ID
    const savedByUsers = pickRandomUsers(link.saveCount);
    const savedByUids = savedByUsers.map(u => u.uid);

    const data = {
      id: docRef.id,
      url: link.url,
      title: link.title,
      hour: link.hour,
      minute: link.minute,
      repeatDays: link.repeatDays,
      sharedBy: CREATOR_NICKNAME,
      creatorUid: creatorUid,
      createdAt: new Date().toISOString(),
      viewCount: Math.floor(Math.random() * 500) + link.saveCount,
      isLocked: false,
      savedByUids: savedByUids,
      soundId: null,
      languageCode: 'en',
      // 새로 추가된 필드 (sharedLinkId 기반)
      saveCount: link.saveCount,
      savedBy: savedByUsers,
    };

    batch.set(docRef, data);
    createdIds.push({ title: link.title, id: docRef.id, saveCount: link.saveCount });
    console.log(`  ${link.title}: ${link.saveCount} saves (id: ${docRef.id})`);
  }

  await batch.commit();

  console.log('\n=== Shared Link IDs (앱에서 링크 추가 시 사용) ===\n');
  for (const item of createdIds) {
    console.log(`  ${item.title}`);
    console.log(`    sharedLinkId: ${item.id}`);
    console.log(`    saveCount: ${item.saveCount}\n`);
  }

  console.log('Done! 시뮬레이터에서 위 sharedLinkId로 공유 링크를 저장하면 Saved by가 표시됩니다.');

  fs.unlinkSync(adcPath);
  process.exit(0);
}

seedData().catch(err => {
  console.error('Error:', err);
  try { fs.unlinkSync(adcPath); } catch(_) {}
  process.exit(1);
});
