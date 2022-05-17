# 教師あり学習 回帰 メモ

scikitlearn.datasetを使って重回帰分析アルゴリズムで数値予測を実装する際のメモ。

[Chainerチュートリアル](https://tutorials.chainer.org/ja/07_Regression_Analysis.html)

## データセットの用意

```py
from sklearn.datasets import load_boston
dataset = load_boston()

# numpy配列形式のデータセットをDataFrameに変換する
x, t = dataset.data, dataset.target
columns = dataset.feature_names
df = pd.DataFrame(x, columns=columns)

# Target列を追加する
df['Target'] = t
```

## numpy配列に変換する

機械学習アルゴリズムに与えるデータは基本的にnumpy配列なので、また変換する。

```py
# 目標値のみ取り出す
t = df['Target'].values

# 目標値以外の変数のみ取り出す
# axis引数で行方向か列方向かを指定
x = df.drop(labels=['Target'], axis=1).values
```

## 訓練データとテストデータに分ける

精度を評価するために、訓練データとテストデータに重複があってはならない。

sklearn.model_selectionにtrain_test_splitというメソッドがある。

```py
from sklearn.model_selection import train_test_split
# test_sizeはテストデータの割合
# random_stateは乱数のシード（分割の仕方）
x_train, x_test, t_train, t_test = train_test_split(x, t, test_size=0.3, random_state=0)
```

## 線形回帰アルゴリズムでモデルを作る

```py
from sklearn.linear_model import LinearRegression
# インスタンス生成
model = LinearRegression()
# fitメソッドで学習させる
model.fit(x_train, t_train)

# 重み係数を確認する
model.coef_

# バイアスの大きさ
model.intercept_

# 各特徴量の重み係数を棒グラフで可視化
plt.figure(figsize=(10, 7))
plt.bar(x=columns, height=model.coef_)

# 決定係数の確認
print(f'train score: {model.score(x_train, t_train)}')
print(f'test score: {model.score(x_test, t_test)} ')
# train score: 0.7645451026942549
# test score: 0.6733825506400171 
```

## モデルを使って数値予測を行う

```py
y = model.predict(x_test)
print(f'予測値: {y[0]}')
print(f'目標値: {t_test[0]}')
# 予測値: 24.935707898576915
# 目標値: 22.6
```

## 過学習を抑制する

過学習とは、機械学習において訓練データに適合しすぎて予測精度が落ちる現象。英語でoverfittingという。
訓練データの外れ値やノイズまで忠実に再現してしまうことが原因。

過学習を抑制するアプローチは大きく三つある。

- データセットのサンプル数を増やす
- ハイパーパラメータを調整する
- 他のアルゴリズムを使用する

### 多重共線性

説明変数の中に相関係数が高い組み合わせが存在することを多重共線性といい、その影響で決定係数が大きくなってしまう。

対策として、相関係数が高い変数のどちらかを除外する、PLSなどの変数を無相関になるように変換した線形回帰アルゴリズムを使用する、などのアプローチがある。

### 説明変数の相関を見る

pandas.DataFrameのcorr()メソッドで相関係数を計算できる。

```py
df_corr = df.corr()
df_corr
```

seabornというMatplotlibのラッパーライブラリを使い、ヒートマップで可視化する。

```py
import matplotlib.pyplot as plt
import seaborn as sns
# ヒートマップで可視化
plt.figure(figsize=(12, 8))
# annotオプションで数値を表示する
sns.heatmap(df_corr.iloc[:20, :20], annot=True)
```

### PLS(Partial Least Squares)

線形回帰アルゴリズムのひとつで、説明変数間の相関が高くても使用できる。
内部的に主成分分析を用いて、任意の数の新たな特徴性を生成し、使用している。

```py
from sklearn.cross_decomposition import PLSRegression
pls = PLSRegression(n_components=11)
pls.fit(x_train, t_train)
print(f'train score: {pls.score(x_train, t_train)}')
print(f'test score: {pls.score(x_test, t_test)} ')
# train score: 0.906376310202351
# test score: 0.7387281471807325 
```

PLSRegressionのコンストラクタに渡しているn_componentsという変数は、潜在変数の数。
このように人間の任意性のある変数のことをハイパーパラメータという。
ここでn_componentsの値に正解はなく、値を変えながら試行錯誤して精度が高くなる値を見つける。
