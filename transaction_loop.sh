source account_50.txt

for i in {1..100}; do
    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0025_name $user0026_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0026_name $user0027_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0027_name $user0028_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0028_name $user0029_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0029_name $user0030_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0030_name $user0031_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0031_name $user0032_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0032_name $user0033_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0033_name $user0034_name "10.0000 QAQ" ""

    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0034_name $user0035_name "10.0000 QAQ" ""
    
    sleep $(python3 -c "import random; print(random.randint(0,20)/10)")
    cleos -u http://localhost:8800 transfer $user0035_name $user0025_name "10.0000 QAQ" ""
done
