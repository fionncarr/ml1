if defined QLIC_KC (
        pip -q install -r requirements.txt
        curl -fsSL -o test.q https://github.com/KxSystems/embedpy/raw/master/test.q
        q test.q utils\tests fresh\tests
)
