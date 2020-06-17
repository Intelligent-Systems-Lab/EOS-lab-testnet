import random 
r = random.sample(range(1,25), 5)
print('cleos -u http://localhost:8800 system voteproducer prods ${!user_name}',end=' ')
for i in r :
    print('$'+'user'+str('{0:04}'.format(i))+'_name ',end=' ')
