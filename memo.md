### 実際のコード

```
def exist_recipe_file?
  File.exist?(recipe_file_path) or raise "#{recipe_file_path} does not exist."
end
```
### どうしてリーダブルだと思っているかの説明

メソッド名を実際に使用するとき`if exist_recipe_file?`みたいにかけるので直感的にわかりやすそう

### この書き方の一言説明

自然言語っぽい

---

### 実際のコード

```
def recipes
  @recipes ||= load_recipe_file
end
```
### どうしてリーダブルだと思っているかの説明

`recipes`をloadする部分を`load_recipe_file`メソッドにまかせているので`recipes`にはロードしたレシピのファイルが入ることわかる

### この書き方の一言説明

移譲

---

### 実際のコード

```
def all_with_id
  recipes.map.with_index(1) { |recipe, i| "#{i}: #{recipe}" }
end
```
### どうしてリーダブルだと思っているかの説明

`all`メソッドがrecipesを返すのでidが付いているので`_with_id`をつけた．  
`map.with_index`を使ってコードを簡潔にした

### この書き方の一言説明

map
