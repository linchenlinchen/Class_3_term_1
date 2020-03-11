import time

from sklearn.model_selection import train_test_split



import numpy as np





class PMF(object):

    def __init__(self, Klatentvariable=10, lamda=0.3, alpha=1, epoch=65, momentum=0.4):

        self.Klatentvariable = Klatentvariable

        self.lamda = lamda

        self.alpha = alpha

        self.epoch = epoch

        self.momentum = momentum



        self.user_num = 0

        self.item_num = 0

        self.R = None

        self.I = None

        self.F_user = None

        self.G_item = None

        self.train_set = None

        self.test_set = None

        self.train_rmse = []

        self.test_rmse = []



    def set_params(self, parameters):

        if isinstance(parameters, dict):

            self.Klatentvariable = parameters.get("Klatentvariable", 10)

            self.lamda = parameters.get("lamda", 0.3)

            self.epoch = parameters.get("epoch", 65)

            self.alpha = parameters.get("alpha", 1)

            self.momentum = parameters.get("momentum", 0.4)



    def fit(self, train, test=None):

        self.mean_v = np.mean(train[:, 2])

        self.train_set = train

        if test is not None:

            self.test_set = test

            self.user_num = int(max(np.amax(train[:, 0]), np.amax(test[:, 0]))) + 1

            self.item_num = int(max(np.amax(train[:, 1]), np.amax(test[:, 1]))) + 1

        else:

            self.user_num = int(np.amax(train[:, 0])) + 1

            self.item_num = int(np.amax(train[:, 1])) + 1

        self.R = np.zeros((self.user_num, self.item_num))

        self.I = np.zeros((self.user_num, self.item_num))

        for index in range(len(train)):

            userid = int(train[index][0])

            itemid = int(train[index][1])

            self.R[userid][itemid] = train[index][2]

            self.I[userid][itemid] = 1

        if self.F_user is None:

            self.F_user = 0.1 * np.random.randn(self.Klatentvariable, self.user_num)

        if self.G_item is None:

            self.G_item = 0.1 * np.random.randn(self.Klatentvariable, self.item_num)

        print("Well prepared for SGD")

        self.SGD()



    def SGD(self):

        G_item_inc = np.zeros((self.Klatentvariable, self.item_num))  # 鍒涘缓鐢靛奖 M x D 0鐭╅樀

        F_user_inc = np.zeros((self.Klatentvariable, self.user_num))  # 鍒涘缓鐢ㄦ埛 N x D 0鐭╅樀

        epoch = 0

        lamda = self.lamda

        alpha = self.alpha



        num_batches = 100

        batch_size = 1000

        mean_inv = np.mean(self.train_set[:, 2])  # 璇勫垎骞冲潎鍊?
        momentum = 0.95

        while (epoch < self.epoch):

            # print("enpoch now is %s" % enpoch)

            epoch += 1

            # G_item_inc = self.G_item.copy()

            # F_user_inc = self.F_user.copy()

            shuffled_order = np.arange(self.train_set.shape[0])  # 鏍规嵁璁板綍鏁板垱寤虹瓑宸產rray

            np.random.shuffle(shuffled_order)

            # print(shuffled_order)

            momentum -= (0.95 - self.momentum) / self.epoch

            # Batch update

            for batch in range(num_batches):  # 姣忔杩唬瑕佷娇鐢ㄧ殑鏁版嵁閲?
                # print("epoch %d batch %d" % (enpoch, batch + 1))

                test = np.arange(batch_size * batch, batch_size * (batch + 1))

                batch_idx = np.mod(test, shuffled_order.shape[0])  # 鏈杩唬瑕佷娇鐢ㄧ殑绱㈠紩涓嬫爣

                batch_UserID = np.array(self.train_set[shuffled_order[batch_idx], 0], dtype='int32')

                batch_ItemID = np.array(self.train_set[shuffled_order[batch_idx], 1], dtype='int32')

                # Compute Objective Function

                pred_out = np.sum(np.multiply(self.F_user[:, batch_UserID].T,

                                              self.G_item[:, batch_ItemID].T),

                                  axis=1)  # np.multiply瀵瑰簲浣嶇疆鍏冪礌鐩镐箻,棰勬祴鐨勭粨鏋?
                rawErr = pred_out - self.train_set[shuffled_order[batch_idx], 2] + mean_inv  # mean_inv subtracted,璇樊鍊?
                # print(rawErr)

                # Compute gradients

                Ix_User = 2 * np.multiply(rawErr[:, np.newaxis], self.G_item[:, batch_ItemID].T) \

                          + lamda * self.F_user[:, batch_UserID].T

                Ix_Item = 2 * np.multiply(rawErr[:, np.newaxis], self.F_user[:, batch_UserID].T) \

                          + lamda * self.G_item[:, batch_ItemID].T  # np.newaxis :increase the dimension

                # 瀵兼暟鍊硷紝涓婇潰閭ｄ釜鏈夐噸澶嶏紝鎶婇噸澶嶇殑鍔犲埌涓€璧?
                dw_Item = np.zeros((self.Klatentvariable, self.item_num))

                dw_User = np.zeros((self.Klatentvariable, self.user_num))

                # loop to aggreate the gradients of the same element

                for i in range(batch_size):

                    dw_Item[:, batch_ItemID[i]] += Ix_Item[i, :]

                    dw_User[:, batch_UserID[i]] += Ix_User[i, :]

                # Update with momentum

                G_item_inc = momentum * G_item_inc + alpha * dw_Item / batch_size

                F_user_inc = momentum * F_user_inc + alpha * dw_User / batch_size

                self.G_item = self.G_item - G_item_inc

                self.F_user = self.F_user - F_user_inc



                # Compute rmse

                if batch == num_batches - 1:

                    # Compute test_rmse

                    pred_out = np.sum(np.multiply(self.F_user[:, np.array(self.test_set[:, 0], dtype='int32')].T,

                                                  self.G_item[:, np.array(self.test_set[:, 1], dtype='int32')].T),

                                      axis=1)  # np.multiply瀵瑰簲浣嶇疆鍏冪礌鐩镐箻,棰勬祴鐨勭粨鏋?
                    rawErr = pred_out - self.test_set[:, 2] + mean_inv  # mean_inv subtracted,璇樊鍊?
                    self.test_rmse.append(np.sqrt((rawErr ** 2).mean()))

                    # Compute train_rmse

                    pred_out = np.sum(np.multiply(self.F_user[:, np.array(self.train_set[:, 0], dtype='int32')].T,

                                                  self.G_item[:, np.array(self.train_set[:, 1], dtype='int32')].T),

                                      axis=1)  # mean_inv subtracted

                    rawErr = pred_out - self.train_set[:, 2] + mean_inv  # mean_inv subtracted,璇樊鍊?
                    self.train_rmse.append(np.sqrt((rawErr ** 2).mean()))

                    # Print info

                    print('epoch:%d, Training RMSE: %f, Test RMSE %f' % (

                        epoch, self.train_rmse[-1], self.test_rmse[-1]))

        # print("SGD finished, epoch now is %s" % epoch)



    def predict(self, user_id, item_id):

        return self.standardize(np.dot(self.F_user[:, int(user_id)], self.G_item[:, int(item_id)]) + self.mean_v)



    def get_rmse(self):

        result = []

        for index in range(len(self.test_set)):

            user = self.test_set[index][0]

            item = self.test_set[index][1]

            result.append(self.predict(user, item))

        test = [self.test_set[:, 2]]

        rmse = np.sqrt(((np.array(result) - np.array(test)) ** 2).mean())

        return rmse



    def standardize_rmse(self):

        result = []

        for index in range(len(self.test_set)):

            user = self.test_set[index][0]

            item = self.test_set[index][1]

            predic = self.standardize2(self.predict(user, item))

            result.append(predic)

        test = [self.test_set[:, 2]]

        rmse = np.sqrt(((np.array(result) - np.array(test)) ** 2).mean())

        return rmse



    def standardize(self, num):

        if num > 5.0:

            return 5.0

        elif num < 0.5:

            return 0.5

        return num



def standardize2(self, num):
    tail = num % 1
    if tail <= 0.25:

        tail = 0

    elif tail >= 0.75:

        tail = 1

    else:

        tail = 0.5

    return int(num) + tail





def get_recommendations(trainfilename, predictfilename):

    start_time = time.time()

    train = init(trainfilename)

    target = init(predictfilename, rating=False)

    pmf = PMF()

    pmf.set_params({"Klatentvariable": 10, "lamda": 0.3, "alpha": 1, "epoch": 65, "momentum": 0.4})

    pmf.fit(train, train)

    result = []

    for index in range(len(target)):

        user = target[index][0]

        item = target[index][1]

        result.append(pmf.predict(user, item))

    end_time = time.time()

    result = np.array(result)

    np.savetxt("optimized_result.csv", result.T, delimiter=",", header="rating")

    print("鐢ㄦ椂锛?s" % (end_time - start_time))

    return





def get_recommendation(filename, item, user):

    start_time = time.time()

    train = init(filename)

    pmf = PMF()

    pmf.set_params({"Klatentvariable": 10, "lamda": 0.3, "alpha": 1, "epoch": 65, "momentum": 0.4})

    pmf.fit(train, train)

    print(pmf.predict(item, user))

    print("RMSE锛?s" % pmf.get_rmse())

    end_time = time.time()

    print("鐢ㄦ椂锛?s" % (end_time - start_time))

    return





def init(filename, rating=True):

    data = []

    file = open(filename, "r", encoding="UTF-8")

    for line in file.readlines()[1:]:  # 鎵撳紑鎸囧畾鏂囦欢

        if rating:

            (userid, itemid, rating, ts) = line.split(',')  # 鏁版嵁闆嗕腑姣忚鏈?椤?
            uid = int(userid)

            mid = int(itemid)

            rat = float(rating)

            data.append([uid, mid, rat])

        else:

            (userid, itemid) = line.split(',')  # 鏁版嵁闆嗕腑姣忚鏈?椤?
            uid = int(userid)

            mid = int(itemid)

            data.append([uid, mid])

    print('Data preparation finished')

    return np.array(data)





def split(file):

    csv = init(file)

    train, test = train_test_split(csv, test_size=0.2)

    return train, test





def split_and_test(filename, lamda=0.1):

    start_time = time.time()

    train, test = split(filename)

    pmf = PMF()

    pmf.set_params({"Klatentvariable": 10, "lamda": 0.3, "alpha": 1, "epoch": 65, "momentum": 0.4})

    pmf.fit(train, test)

    print("RMSE锛?s" % pmf.get_rmse())

    print("standardized_RMSE锛?s" % pmf.standardize_rmse())



    end_time = time.time()

    print("鐢ㄦ椂锛?s" % (end_time - start_time))

    return





if __name__ == '__main__':

    filename = "train.csv"

    testfilename = "test_index.csv"

    # get_recommendation(filename, 2345, 468)

    # split_and_test(filename)

    # get_recommendations(filename, testfilename)



    # train, test = split(filename)

    # result1 = []

    # for j in range(1, 6):

    #     result2 = []

    #     train, test = split(filename)

    #     for i in range(20, 101, 5):

    #         pmf = PMF()

    #         pmf.set_params({"Klatentvariable": 10, "lamda": 0.3, "alpha": 1, "epoch": i, "momentum": 0.4})

    #         pmf.fit(train, test)

    #         # print("RMSE锛?s" % pmf.get_rmse())

    #         rmses = pmf.test_rmse

    #         rmse = min(rmses)

    #         rmse2 = rmses[-1]

    #         epoch = rmses.index(rmse) + 1

    #         result2.append({"enpoch": i, "rmse": rmse, "epoch": epoch, "rmse2": rmse2})

    #     result1.append(result2)

    #     print(j, result1)

    # print(result1)


