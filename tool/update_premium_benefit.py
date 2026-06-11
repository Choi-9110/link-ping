# premiumBenefit6(제거된 '프리미엄 사운드')를 '클라우드 백업 & 동기화'로 교체.
# 값만 치환(키 보호). 실행: python tool/update_premium_benefit.py
import re

UPDATES = {
    'app_ko.arb': {
        'premiumBenefit6': '클라우드 백업 & 동기화',
        'premiumBenefit6Desc': '폰을 바꿔도 저장한 링크가 그대로 복원돼요',
    },
    'app_en.arb': {
        'premiumBenefit6': 'Cloud Backup & Sync',
        'premiumBenefit6Desc': 'Switch phones anytime — your links restore automatically',
    },
    'app_ja.arb': {
        'premiumBenefit6': 'クラウドバックアップ＆同期',
        'premiumBenefit6Desc': '機種変更しても保存したリンクがそのまま復元されます',
    },
    'app_zh.arb': {
        'premiumBenefit6': '云端备份与同步',
        'premiumBenefit6Desc': '换手机也能自动恢复你保存的链接',
    },
    'app_es.arb': {
        'premiumBenefit6': 'Copia en la nube y sincronización',
        'premiumBenefit6Desc': 'Cambia de teléfono y tus enlaces se restauran solos',
    },
}

base = 'lib/l10n/'
for fn, kv in UPDATES.items():
    path = base + fn
    with open(path, encoding='utf-8') as f:
        lines = f.read().split('\n')
    out = []
    for ln in lines:
        done = False
        for k, v in kv.items():
            m = re.match(r'^(\s*"' + re.escape(k) + r'":\s*")(.*?)("\s*,?\s*)$', ln)
            if m:
                out.append(m.group(1) + v + m.group(3))
                done = True
                break
        if not done:
            out.append(ln)
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('\n'.join(out))
    print('updated', fn)
