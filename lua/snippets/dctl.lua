local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("dctl", {

  -- Full DCTL Scaffold
  s("dctl", {
    t({
      "// --------------------------------------------------",
      "// DCTL: "
    }),
    i(1, "MyTransform"),
    t({
      "",
      "// Author: "
    }),
    f(function() return os.getenv("USER") or "Author" end),
    t({
      "",
      "// --------------------------------------------------",
      "",
      "__DEVICE__ float3 transform(",
      "    int width, int height, int x, int y,",
      "    float r, float g, float b)",
      "{",
      "    float3 rgb = make_float3(r, g, b);",
      "",
      "    "
    }),
    i(2, "// your transform logic"),
    t({
      "",
      "",
      "    return rgb;",
      "}",
    }),
  }),

  -- Slider param
  s("slider", {
    t("DEFINE_UI_PARAMS("),
    i(1, "gain"),
    t(", "),
    i(2, "Gain"),
    t(", DCTLUI_SLIDER_FLOAT, "),
    i(3, "1.0"),
    t(", "),
    i(4, "0.0"),
    t(", "),
    i(5, "4.0"),
    t(", "),
    i(6, "0.01"),
    t(")"),
  }),

  -- Multiply RGB
  s("mul", {
    t("rgb *= "),
    i(1, "gain"),
    t(";"),
  }),

  -- Float3 helper
  s("f3", {
    t("float3 "),
    i(1, "var"),
    t(" = make_float3("),
    i(2, "0.0"),
    t(", "),
    i(3, "0.0"),
    t(", "),
    i(4, "0.0"),
    t(");"),
  }),

})
