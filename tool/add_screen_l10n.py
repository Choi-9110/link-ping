# 도감/전화 로그인 화면의 신규 문자열을 5개 언어 arb에 추가.
# 실행: python tool/add_screen_l10n.py
import json

# key -> {lang: value}  (en/ko/ja/zh/es)
T = {
    # ── 링꾸 도감 ──
    'linkkuDexTitle': {
        'en': 'Linkku Dex', 'ko': '링꾸 도감', 'ja': 'Linkku図鑑',
        'zh': 'Linkku图鉴', 'es': 'Dex de Linkku'},
    'linkkuDexCollect': {
        'en': 'Collect your Linkkus', 'ko': '링꾸를 모아보세요',
        'ja': 'Linkkuを集めよう', 'zh': '收集你的 Linkku', 'es': 'Colecciona tus Linkku'},
    'linkkuDexComingHint': {
        'en': 'New friends are on their way, one by one.',
        'ko': '곧 새로운 친구들이 하나씩 찾아와요.',
        'ja': '新しい仲間が少しずつやってきます。',
        'zh': '新朋友会一个一个到来。', 'es': 'Nuevos amigos llegarán poco a poco.'},
    'linkkuDexDefault': {
        'en': 'Default', 'ko': '기본', 'ja': '基本', 'zh': '默认', 'es': 'Por defecto'},
    'linkkuDexComingSoon': {
        'en': 'Coming soon', 'ko': '곧 만나요', 'ja': '近日登場',
        'zh': '敬请期待', 'es': 'Próximamente'},
    'linkkuDexSubtitle': {
        'en': 'The alarm slime with a bell', 'ko': '벨 달린 알람 슬라임',
        'ja': 'ベル付きのアラームスライム', 'zh': '带铃铛的闹钟史莱姆',
        'es': 'El slime-alarma con campana'},
    'linkkuPersonality': {
        'en': 'Personality', 'ko': '성격', 'ja': '性格', 'zh': '性格', 'es': 'Personalidad'},
    'linkkuTraitCaring': {
        'en': 'Caring', 'ko': '다정한', 'ja': 'やさしい', 'zh': '贴心', 'es': 'Cariñoso'},
    'linkkuTraitAttentive': {
        'en': 'Attentive', 'ko': '챙겨주는', 'ja': '気配り上手', 'zh': '细心', 'es': 'Atento'},
    'linkkuPersonalityDesc': {
        'en': 'A caring friend who never forgets your time.\nSoon, each Linkku gets its own personality — yours will even talk differently.',
        'ko': '약속 시간을 절대 안 까먹는 다정한 친구.\n곧 저마다 다른 성격이 생겨서, 너만의 링꾸는 말투까지 달라질 거예요.',
        'ja': '約束の時間を絶対に忘れないやさしい友だち。\nもうすぐそれぞれ性格がついて、あなたのLinkkuは話し方まで変わります。',
        'zh': '绝不会忘记你时间的贴心朋友。\n很快每只 Linkku 都会有自己的性格，连说话方式都不一样哦。',
        'es': 'Un amigo cariñoso que nunca olvida tu hora.\nPronto cada Linkku tendrá su propia personalidad y hasta hablará distinto.'},
    'linkkuWhatsNext': {
        'en': "What's next", 'ko': '앞으로', 'ja': 'これから', 'zh': '接下来', 'es': 'Lo que viene'},
    'linkkuWhatsNextDesc': {
        'en': 'Raising, dressing up, and collecting new friends are coming step by step. 🥚',
        'ko': '링꾸를 키우고, 꾸미고, 새 친구들을 모으는 기능이 차근차근 찾아와요. 🥚',
        'ja': '育てて、着せ替えて、新しい仲間を集める機能が少しずつやってきます。🥚',
        'zh': '养成、装扮、收集新朋友的功能会逐步到来。🥚',
        'es': 'Criar, vestir y coleccionar nuevos amigos llegará paso a paso. 🥚'},
    # ── 전화 로그인 ──
    'phoneSignIn': {
        'en': 'Sign in with phone', 'ko': '전화번호로 로그인', 'ja': '電話番号でログイン',
        'zh': '用手机号登录', 'es': 'Iniciar sesión con teléfono'},
    'phoneEnterCode': {
        'en': 'Enter the code', 'ko': '인증번호를 입력하세요', 'ja': '認証コードを入力',
        'zh': '请输入验证码', 'es': 'Introduce el código'},
    'phoneEnterNumber': {
        'en': 'Enter your phone number', 'ko': '휴대폰 번호를 입력하세요',
        'ja': '電話番号を入力してください', 'zh': '请输入手机号', 'es': 'Introduce tu número'},
    'phoneNumberLabel': {
        'en': 'Phone number', 'ko': '휴대폰 번호', 'ja': '電話番号',
        'zh': '手机号', 'es': 'Número de teléfono'},
    'phoneSendCode': {
        'en': 'Send code', 'ko': '인증번호 받기', 'ja': 'コードを送信',
        'zh': '获取验证码', 'es': 'Enviar código'},
    'phoneConfirm': {
        'en': 'Confirm', 'ko': '확인', 'ja': '確認', 'zh': '确认', 'es': 'Confirmar'},
    'phoneChangeNumber': {
        'en': 'Change number', 'ko': '번호 다시 입력', 'ja': '番号を変更',
        'zh': '重新输入号码', 'es': 'Cambiar número'},
    'phoneCodeSent': {
        'en': 'Verification code sent', 'ko': '인증번호를 보냈어요',
        'ja': '認証コードを送りました', 'zh': '验证码已发送', 'es': 'Código enviado'},
    'phoneSendFailed': {
        'en': 'Failed to send code', 'ko': '인증번호 전송 실패',
        'ja': '認証コードの送信に失敗しました', 'zh': '验证码发送失败', 'es': 'No se pudo enviar el código'},
    'phoneVerifyFailed': {
        'en': 'Verification failed', 'ko': '인증 실패',
        'ja': '認証に失敗しました', 'zh': '验证失败', 'es': 'Verificación fallida'},
    'phoneGenericError': {
        'en': 'Something went wrong', 'ko': '오류가 발생했어요',
        'ja': 'エラーが発生しました', 'zh': '出错了', 'es': 'Algo salió mal'},
}

LANGS = ['en', 'ko', 'ja', 'zh', 'es']
base = 'lib/l10n/'
for lang in LANGS:
    path = base + 'app_%s.arb' % lang
    arb = json.load(open(path, encoding='utf-8'))
    added = 0
    for key, vals in T.items():
        if key not in arb:
            arb[key] = vals[lang]
            added += 1
    json.dump(arb, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
    print(lang, 'added', added)
