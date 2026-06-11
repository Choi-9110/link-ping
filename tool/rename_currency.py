# 통화 "포링→핑" + 기능 "ping→찌르기/poke" l10n 값 치환기.
# 키는 '": "' 구분자 앞(head)에 있으므로 절대 건드리지 않고, 값만 치환한다.
# 실행: python tool/rename_currency.py
import os

CURRENCY = {
    'app_ko.arb': [('포링', '핑')],
    'app_ja.arb': [('ポリング', 'ピン')],
    'app_zh.arb': [('波灵', 'Ping'), ('Poring', 'Ping')],
    'app_en.arb': [('Porings', 'Pings'), ('Poring', 'Ping')],
    'app_es.arb': [('Porings', 'Pings'), ('Poring', 'Ping')],
}
FEATURE = {
    'app_ko.arb': [('Ping 알림음', '찌르기 알림음')],
    'app_en.arb': [
        ('1 free ping available', '1 free poke available'),
        ('Ping Sound', 'Poke Sound'),
        ('Sound for Ping and Cheer', 'Sound for Poke and Cheer'),
    ],
    'app_ja.arb': [('ピンと応援通知のサウンド', 'つつきと応援の通知音')],
    'app_es.arb': [('1 ping gratis disponible', '1 toque gratis disponible')],
}

SEP = '": "'
base = 'lib/l10n/'

for fn, pairs in CURRENCY.items():
    path = os.path.join(base, fn)
    with open(path, encoding='utf-8') as f:
        lines = f.read().split('\n')
    allpairs = pairs + FEATURE.get(fn, [])
    out = []
    for ln in lines:
        i = ln.find(SEP)
        if i == -1:
            out.append(ln)
            continue
        head = ln[:i + len(SEP)]   # '  "key": "'  (키 보호)
        rest = ln[i + len(SEP):]   # 'value",'
        for a, b in allpairs:
            rest = rest.replace(a, b)
        out.append(head + rest)
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(out))
    print('updated', fn)
