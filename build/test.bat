if defined QLIC_KC (
        pip -q install -r requirements.txt
        q freshq\test.q -q
        q mlutils\test.q -q
)
