local ls = require("luasnip")

return {
  ls.snippet("cf", {
    ls.text_node({
      "#include <iostream>",
      "#include <vector>",
      "#include <algorithm>",
      "#include <map>",
      "#include <string>",
      "#include <unordered_map>",
      "#include <cmath>",
      "#define ll long long",
      "using namespace std;",
      "",
      "",
      "int main()",
      "{",
      "    ios::sync_with_stdio(false);",
      "    cin.tie(nullptr);",
      "",
      "    int T;",
      "    cin >> T;",
      "    while (T--)",
      "    {",
      "        ",
    }),
    ls.insert_node(1),
    ls.text_node({
      "",
      "    }",
      "}",
    }),
    ls.insert_node(0),
  }),
  ls.snippet("endl", {
    ls.text_node({ '"\\n";' }),
  }),
}
