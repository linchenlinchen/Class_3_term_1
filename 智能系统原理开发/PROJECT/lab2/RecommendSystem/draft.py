# Message = [[2,'Mike'],[1,'Jone'],[2,'Marry']]
# dict1 = {}
# for number in Message:
#     value = number[0]
#     if value not in dict1.keys():
#         dict1[value] = [number]          #此句话玄机
#     else:
#         dict1[value].append(number)
# print(dict1)
L = ['1','4']
L.append('3')
print(L)

L1 = ['Google', 'Runoob', 'Taobao']
L1.append('Baidu')
print("更新后的列表 : ", L1)