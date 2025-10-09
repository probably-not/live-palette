import js from "@eslint/js";
import eslintConfigPrettier from "eslint-config-prettier/flat";
import { defineConfig } from "eslint/config";
import globals from "globals";
import tseslint from "typescript-eslint";

const ignores = ["vendor/*", "demo/*"];
const recommendedTsConfig = tseslint.configs.recommended.map((cfg) => {
  return { ...cfg, ignores: ignores.concat(cfg.ignores || []) };
});

export default defineConfig([
  {
    files: ["**/*.{js,mjs,cjs,ts}"],
    plugins: { js },
    extends: ["js/recommended"],
    ignores: ignores,
  },
  {
    files: ["**/*.{js,mjs,cjs,ts}"],
    languageOptions: { globals: { ...globals.browser, liveSocket: true } },
    ignores: ignores,
  },
  recommendedTsConfig,
  {
    files: ["**/*.{js,mjs,cjs,ts}"],
    ignores: ignores,
    rules: {
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          args: "all",
          argsIgnorePattern: "^_",
          caughtErrors: "all",
          caughtErrorsIgnorePattern: "^_",
          destructuredArrayIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          ignoreRestSiblings: true,
        },
      ],
    },
  },
  eslintConfigPrettier,
]);
