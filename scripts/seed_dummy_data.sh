#!/bin/bash
# 더미 데이터를 Firebase Firestore에 직접 넣는 스크립트

PROJECT="linkping-prod"

# 더미 유저 목록
declare -a USERS=(
  '{"uid":"dummy_01","nickname":"Wandering April Tiger","profileEmoji":"face_grinning","country":"US"}'
  '{"uid":"dummy_02","nickname":"Dreamy June Owl","profileEmoji":"face_heart_eyes","country":"GB"}'
  '{"uid":"dummy_03","nickname":"Silent March Fox","profileEmoji":"face_sunglasses","country":"JP"}'
  '{"uid":"dummy_04","nickname":"Golden Autumn Deer","profileEmoji":"face_star_struck","country":"KR"}'
  '{"uid":"dummy_05","nickname":"Crystal Winter Cat","profileEmoji":"face_winking","country":"DE"}'
  '{"uid":"dummy_06","nickname":"Velvet Spring Lily","profileEmoji":"face_smiling","country":"FR"}'
  '{"uid":"dummy_07","nickname":"Sparkling May Firefly","profileEmoji":"face_zany","country":"AU"}'
  '{"uid":"dummy_08","nickname":"Midnight July Wolf","profileEmoji":"face_cowboy","country":"CA"}'
  '{"uid":"dummy_09","nickname":"Gentle Dawn Rabbit","profileEmoji":"face_nerd","country":"BR"}'
  '{"uid":"dummy_10","nickname":"Misty October Cloud","profileEmoji":"face_partying","country":"ES"}'
  '{"uid":"dummy_11","nickname":"Curious Summer Breeze","profileEmoji":"face_monocle","country":"IT"}'
  '{"uid":"dummy_12","nickname":"Floating Snow Cherry","profileEmoji":"face_pleading","country":"NL"}'
  '{"uid":"dummy_13","nickname":"Lazy Twilight Maple","profileEmoji":"face_relieved","country":"SE"}'
  '{"uid":"dummy_14","nickname":"Dancing Rain Willow","profileEmoji":"face_yum","country":"NZ"}'
  '{"uid":"dummy_15","nickname":"Whispering Moon Dew","profileEmoji":"face_innocent","country":"SG"}'
)

# 링크별 데이터 (urlHash, saveCount)
declare -A LINKS
LINKS["6e63346f"]='{"title":"Morning Yoga Routine","count":175}'
LINKS["2c41b95d"]='{"title":"Daily English Practice","count":89}'
LINKS["237c73d7"]='{"title":"Read 10 Pages","count":13}'
LINKS["1361d116"]='{"title":"Check Portfolio","count":8}'
LINKS["1f97d44a"]='{"title":"Meditation 15min","count":42}'
LINKS["4d16f180"]='{"title":"Call Mom","count":6}'
LINKS["6c9f63e6"]='{"title":"Weekly Meal Prep","count":11}'
LINKS["75088901"]='{"title":"Side Project Todo","count":7}'
LINKS["585abd67"]='{"title":"Stretch & Walk","count":9}'
LINKS["10b0e8a8"]='{"title":"Journal Writing","count":5}'

echo "Seeding dummy data to Firestore..."

for hash in "${!LINKS[@]}"; do
  info="${LINKS[$hash]}"
  title=$(echo "$info" | python3 -c "import sys,json; print(json.load(sys.stdin)['title'])")
  count=$(echo "$info" | python3 -c "import sys,json; print(json.load(sys.stdin)['count'])")

  # savedBy 배열 만들기 (최대 15명)
  max_users=$((count < 15 ? count : 15))
  saved_by="["
  for ((i=0; i<max_users; i++)); do
    if [ $i -gt 0 ]; then saved_by+=","; fi
    saved_by+="${USERS[$i]}"
  done
  saved_by+="]"

  echo "  $title: $count saves (hash: $hash)"

  # Firebase REST API로 직접 쓰기
  firebase firestore:delete --project "$PROJECT" "urlStats/$hash" --force 2>/dev/null

  # firebase CLI로 문서 설정
  node -e "
    process.env.GOOGLE_APPLICATION_CREDENTIALS = '';
    const {exec} = require('child_process');
    const data = {
      saveCount: $count,
      savedBy: $saved_by,
      createdAt: new Date().toISOString()
    };
    console.log(JSON.stringify(data));
  " | firebase firestore:set --project "$PROJECT" "urlStats/$hash" --force 2>/dev/null
done

echo "Done!"
