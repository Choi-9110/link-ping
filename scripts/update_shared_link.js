const fs = require('fs');
const path = require('path');
const admin = require('../functions/node_modules/firebase-admin');

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

// 이 sharedLinkId에 더미 savedBy 데이터 넣기
const SHARED_LINK_ID = 'JVkzfxUgRDbJpO7sO3k0';
const SAVE_COUNT = 175;

async function update() {
  console.log(`Updating sharedLink ${SHARED_LINK_ID}...`);

  const savedByUids = dummyUsers.map(u => u.uid);

  await db.collection('sharedLinks').doc(SHARED_LINK_ID).update({
    saveCount: SAVE_COUNT,
    savedBy: dummyUsers,
    savedByUids: savedByUids,
  });

  console.log(`Done! saveCount: ${SAVE_COUNT}, savedBy: ${dummyUsers.length} users`);

  fs.unlinkSync(adcPath);
  process.exit(0);
}

update().catch(err => {
  console.error('Error:', err);
  try { fs.unlinkSync(adcPath); } catch(_) {}
  process.exit(1);
});
