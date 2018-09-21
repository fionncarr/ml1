if defined QLIC_KC (
        pip -q install -r requirements.txt
        q test.q fresh\tests utils\tests
)
