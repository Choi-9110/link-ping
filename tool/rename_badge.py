# "뱃지/Badge" → "업적/Achievement" l10n 값 치환 (키 보호, 값만).
# 실행: python tool/rename_badge.py
import re

# 언어별 치환 (긴 것/복수형 먼저)
RULES = {
    'app_ko.arb': [('뱃지', '업적'), ('배지', '업적')],
    'app_en.arb': [
        ('Badges', 'Achievements'), ('Badge', 'Achievement'),
        ('badges', 'achievements'), ('badge', 'achievement'),
    ],
    'app_ja.arb': [('バッジ', '実績')],
    'app_zh.arb': [('徽章', '成就')],
    'app_es.arb': [
        ('Insignias', 'Logros'), ('Insignia', 'Logro'),
        ('insignias', 'logros'), ('insignia', 'logro'),
    ],
}

SEP = '": "'
base = 'lib/l10n/'

for fn, pairs in RULES.items():
    path = base + fn
    with open(path, encoding='utf-8') as f:
        lines = f.read().split('\n')
    out = []
    for ln in lines:
        i = ln.find(SEP)
        if i == -1:
            out.append(ln)
            continue
        head = ln[:i + len(SEP)]   # 키 보호
        rest = ln[i + len(SEP):]   # 값 + 꼬리
        for a, b in pairs:
            rest = rest.replace(a, b)
        out.append(head + rest)
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(out))
    print('updated', fn)
