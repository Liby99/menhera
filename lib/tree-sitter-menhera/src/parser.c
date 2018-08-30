#include <tree_sitter/parser.h>

#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"
#endif

#define LANGUAGE_VERSION 9
#define STATE_COUNT 119
#define SYMBOL_COUNT 37
#define ALIAS_COUNT 0
#define TOKEN_COUNT 17
#define EXTERNAL_TOKEN_COUNT 0
#define MAX_ALIAS_SEQUENCE_LENGTH 0

enum {
  sym_integer = 1,
  sym_identifier = 2,
  anon_sym_COMMA = 3,
  anon_sym_LPAREN = 4,
  anon_sym_RPAREN = 5,
  anon_sym_DASH_GT = 6,
  anon_sym_COLON = 7,
  anon_sym_PLUS = 8,
  anon_sym_DASH = 9,
  anon_sym_STAR = 10,
  anon_sym_SLASH = 11,
  anon_sym_PERCENT = 12,
  anon_sym_let = 13,
  anon_sym_EQ = 14,
  anon_sym_in = 15,
  anon_sym_EQ_GT = 16,
  sym_source_file = 17,
  sym_arguments = 18,
  sym_expressions = 19,
  sym_types = 20,
  sym_paren_expr = 21,
  sym_unit_expr = 22,
  sym_compound_expr = 23,
  sym_type = 24,
  sym_unit_type = 25,
  sym_function_type = 26,
  sym_dec_var = 27,
  sym_just_var = 28,
  sym_typed_var = 29,
  sym_expr_int = 30,
  sym_expr_var = 31,
  sym_expr_bin_op = 32,
  sym_expr_let = 33,
  sym_expr_function = 34,
  sym_expr_application = 35,
  sym_expr = 36,
};

static const char *ts_symbol_names[] = {
  [ts_builtin_sym_end] = "END",
  [sym_integer] = "integer",
  [sym_identifier] = "identifier",
  [anon_sym_COMMA] = ",",
  [anon_sym_LPAREN] = "(",
  [anon_sym_RPAREN] = ")",
  [anon_sym_DASH_GT] = "->",
  [anon_sym_COLON] = ":",
  [anon_sym_PLUS] = "+",
  [anon_sym_DASH] = "-",
  [anon_sym_STAR] = "*",
  [anon_sym_SLASH] = "/",
  [anon_sym_PERCENT] = "%",
  [anon_sym_let] = "let",
  [anon_sym_EQ] = "=",
  [anon_sym_in] = "in",
  [anon_sym_EQ_GT] = "=>",
  [sym_source_file] = "source_file",
  [sym_arguments] = "arguments",
  [sym_expressions] = "expressions",
  [sym_types] = "types",
  [sym_paren_expr] = "paren_expr",
  [sym_unit_expr] = "unit_expr",
  [sym_compound_expr] = "compound_expr",
  [sym_type] = "type",
  [sym_unit_type] = "unit_type",
  [sym_function_type] = "function_type",
  [sym_dec_var] = "dec_var",
  [sym_just_var] = "just_var",
  [sym_typed_var] = "typed_var",
  [sym_expr_int] = "expr_int",
  [sym_expr_var] = "expr_var",
  [sym_expr_bin_op] = "expr_bin_op",
  [sym_expr_let] = "expr_let",
  [sym_expr_function] = "expr_function",
  [sym_expr_application] = "expr_application",
  [sym_expr] = "expr",
};

static const TSSymbolMetadata ts_symbol_metadata[] = {
  [ts_builtin_sym_end] = {
    .visible = false,
    .named = true,
  },
  [sym_integer] = {
    .visible = true,
    .named = true,
  },
  [sym_identifier] = {
    .visible = true,
    .named = true,
  },
  [anon_sym_COMMA] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_LPAREN] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_RPAREN] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_DASH_GT] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_COLON] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_PLUS] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_DASH] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_STAR] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_SLASH] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_PERCENT] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_let] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_EQ] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_in] = {
    .visible = true,
    .named = false,
  },
  [anon_sym_EQ_GT] = {
    .visible = true,
    .named = false,
  },
  [sym_source_file] = {
    .visible = true,
    .named = true,
  },
  [sym_arguments] = {
    .visible = true,
    .named = true,
  },
  [sym_expressions] = {
    .visible = true,
    .named = true,
  },
  [sym_types] = {
    .visible = true,
    .named = true,
  },
  [sym_paren_expr] = {
    .visible = true,
    .named = true,
  },
  [sym_unit_expr] = {
    .visible = true,
    .named = true,
  },
  [sym_compound_expr] = {
    .visible = true,
    .named = true,
  },
  [sym_type] = {
    .visible = true,
    .named = true,
  },
  [sym_unit_type] = {
    .visible = true,
    .named = true,
  },
  [sym_function_type] = {
    .visible = true,
    .named = true,
  },
  [sym_dec_var] = {
    .visible = true,
    .named = true,
  },
  [sym_just_var] = {
    .visible = true,
    .named = true,
  },
  [sym_typed_var] = {
    .visible = true,
    .named = true,
  },
  [sym_expr_int] = {
    .visible = true,
    .named = true,
  },
  [sym_expr_var] = {
    .visible = true,
    .named = true,
  },
  [sym_expr_bin_op] = {
    .visible = true,
    .named = true,
  },
  [sym_expr_let] = {
    .visible = true,
    .named = true,
  },
  [sym_expr_function] = {
    .visible = true,
    .named = true,
  },
  [sym_expr_application] = {
    .visible = true,
    .named = true,
  },
  [sym_expr] = {
    .visible = true,
    .named = true,
  },
};

static bool ts_lex(TSLexer *lexer, TSStateId state) {
  START_LEXER();
  switch (state) {
    case 0:
      if (lookahead == 0)
        ADVANCE(1);
      if (lookahead == '%')
        ADVANCE(2);
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == ')')
        ADVANCE(4);
      if (lookahead == '*')
        ADVANCE(5);
      if (lookahead == '+')
        ADVANCE(6);
      if (lookahead == ',')
        ADVANCE(7);
      if (lookahead == '-')
        ADVANCE(8);
      if (lookahead == '/')
        ADVANCE(11);
      if (lookahead == ':')
        ADVANCE(12);
      if (lookahead == '=')
        ADVANCE(13);
      if (lookahead == 'i')
        ADVANCE(15);
      if (lookahead == 'l')
        ADVANCE(17);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(0);
      if (('0' <= lookahead && lookahead <= '9'))
        ADVANCE(10);
      END_STATE();
    case 1:
      ACCEPT_TOKEN(ts_builtin_sym_end);
      END_STATE();
    case 2:
      ACCEPT_TOKEN(anon_sym_PERCENT);
      END_STATE();
    case 3:
      ACCEPT_TOKEN(anon_sym_LPAREN);
      END_STATE();
    case 4:
      ACCEPT_TOKEN(anon_sym_RPAREN);
      END_STATE();
    case 5:
      ACCEPT_TOKEN(anon_sym_STAR);
      END_STATE();
    case 6:
      ACCEPT_TOKEN(anon_sym_PLUS);
      END_STATE();
    case 7:
      ACCEPT_TOKEN(anon_sym_COMMA);
      END_STATE();
    case 8:
      ACCEPT_TOKEN(anon_sym_DASH);
      if (lookahead == '>')
        ADVANCE(9);
      if (('0' <= lookahead && lookahead <= '9'))
        ADVANCE(10);
      END_STATE();
    case 9:
      ACCEPT_TOKEN(anon_sym_DASH_GT);
      END_STATE();
    case 10:
      ACCEPT_TOKEN(sym_integer);
      if (('0' <= lookahead && lookahead <= '9'))
        ADVANCE(10);
      END_STATE();
    case 11:
      ACCEPT_TOKEN(anon_sym_SLASH);
      END_STATE();
    case 12:
      ACCEPT_TOKEN(anon_sym_COLON);
      END_STATE();
    case 13:
      ACCEPT_TOKEN(anon_sym_EQ);
      if (lookahead == '>')
        ADVANCE(14);
      END_STATE();
    case 14:
      ACCEPT_TOKEN(anon_sym_EQ_GT);
      END_STATE();
    case 15:
      if (lookahead == 'n')
        ADVANCE(16);
      END_STATE();
    case 16:
      ACCEPT_TOKEN(anon_sym_in);
      END_STATE();
    case 17:
      if (lookahead == 'e')
        ADVANCE(18);
      END_STATE();
    case 18:
      if (lookahead == 't')
        ADVANCE(19);
      END_STATE();
    case 19:
      ACCEPT_TOKEN(anon_sym_let);
      END_STATE();
    case 20:
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == '-')
        ADVANCE(21);
      if (lookahead == 'l')
        ADVANCE(22);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(20);
      if (('0' <= lookahead && lookahead <= '9'))
        ADVANCE(10);
      if (('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(26);
      END_STATE();
    case 21:
      if (('0' <= lookahead && lookahead <= '9'))
        ADVANCE(10);
      END_STATE();
    case 22:
      if (lookahead == 'e')
        ADVANCE(23);
      if (('0' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(25);
      END_STATE();
    case 23:
      ACCEPT_TOKEN(sym_identifier);
      if (lookahead == 't')
        ADVANCE(24);
      if (('0' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(25);
      END_STATE();
    case 24:
      ACCEPT_TOKEN(anon_sym_let);
      if (('0' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(25);
      END_STATE();
    case 25:
      ACCEPT_TOKEN(sym_identifier);
      if (('0' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(25);
      END_STATE();
    case 26:
      if (('0' <= lookahead && lookahead <= '9') ||
          ('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(25);
      END_STATE();
    case 27:
      if (lookahead == 0)
        ADVANCE(1);
      if (lookahead == '%')
        ADVANCE(2);
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == ')')
        ADVANCE(4);
      if (lookahead == '*')
        ADVANCE(5);
      if (lookahead == '+')
        ADVANCE(6);
      if (lookahead == ',')
        ADVANCE(7);
      if (lookahead == '-')
        ADVANCE(28);
      if (lookahead == '/')
        ADVANCE(11);
      if (lookahead == 'i')
        ADVANCE(15);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(27);
      END_STATE();
    case 28:
      ACCEPT_TOKEN(anon_sym_DASH);
      END_STATE();
    case 29:
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(29);
      if (('A' <= lookahead && lookahead <= 'Z') ||
          lookahead == '_' ||
          ('a' <= lookahead && lookahead <= 'z'))
        ADVANCE(26);
      END_STATE();
    case 30:
      if (lookahead == 0)
        ADVANCE(1);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(30);
      END_STATE();
    case 31:
      if (lookahead == 0)
        ADVANCE(1);
      if (lookahead == '%')
        ADVANCE(2);
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == '*')
        ADVANCE(5);
      if (lookahead == '+')
        ADVANCE(6);
      if (lookahead == '-')
        ADVANCE(28);
      if (lookahead == '/')
        ADVANCE(11);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(31);
      END_STATE();
    case 32:
      if (lookahead == '%')
        ADVANCE(2);
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == ')')
        ADVANCE(4);
      if (lookahead == '*')
        ADVANCE(5);
      if (lookahead == '+')
        ADVANCE(6);
      if (lookahead == ',')
        ADVANCE(7);
      if (lookahead == '-')
        ADVANCE(28);
      if (lookahead == '/')
        ADVANCE(11);
      if (lookahead == ':')
        ADVANCE(12);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(32);
      END_STATE();
    case 33:
      if (lookahead == ')')
        ADVANCE(4);
      if (lookahead == ',')
        ADVANCE(7);
      if (lookahead == '=')
        ADVANCE(34);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(33);
      END_STATE();
    case 34:
      ACCEPT_TOKEN(anon_sym_EQ);
      END_STATE();
    case 35:
      if (lookahead == ':')
        ADVANCE(12);
      if (lookahead == '=')
        ADVANCE(34);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(35);
      END_STATE();
    case 36:
      if (lookahead == ':')
        ADVANCE(12);
      if (lookahead == '=')
        ADVANCE(37);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(36);
      END_STATE();
    case 37:
      if (lookahead == '>')
        ADVANCE(14);
      END_STATE();
    case 38:
      if (lookahead == ')')
        ADVANCE(4);
      if (lookahead == ',')
        ADVANCE(7);
      if (lookahead == '=')
        ADVANCE(13);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(38);
      END_STATE();
    case 39:
      if (lookahead == '%')
        ADVANCE(2);
      if (lookahead == '(')
        ADVANCE(3);
      if (lookahead == '*')
        ADVANCE(5);
      if (lookahead == '+')
        ADVANCE(6);
      if (lookahead == '-')
        ADVANCE(28);
      if (lookahead == '/')
        ADVANCE(11);
      if (lookahead == 'i')
        ADVANCE(15);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(39);
      END_STATE();
    case 40:
      if (lookahead == '-')
        ADVANCE(41);
      if (lookahead == '\t' ||
          lookahead == '\n' ||
          lookahead == '\r' ||
          lookahead == ' ')
        SKIP(40);
      END_STATE();
    case 41:
      if (lookahead == '>')
        ADVANCE(9);
      END_STATE();
    default:
      return false;
  }
}

static TSLexMode ts_lex_modes[STATE_COUNT] = {
  [0] = {.lex_state = 0},
  [1] = {.lex_state = 20},
  [2] = {.lex_state = 27},
  [3] = {.lex_state = 27},
  [4] = {.lex_state = 20},
  [5] = {.lex_state = 29},
  [6] = {.lex_state = 30},
  [7] = {.lex_state = 27},
  [8] = {.lex_state = 27},
  [9] = {.lex_state = 27},
  [10] = {.lex_state = 31},
  [11] = {.lex_state = 32},
  [12] = {.lex_state = 20},
  [13] = {.lex_state = 29},
  [14] = {.lex_state = 32},
  [15] = {.lex_state = 32},
  [16] = {.lex_state = 32},
  [17] = {.lex_state = 33},
  [18] = {.lex_state = 27},
  [19] = {.lex_state = 35},
  [20] = {.lex_state = 35},
  [21] = {.lex_state = 20},
  [22] = {.lex_state = 20},
  [23] = {.lex_state = 20},
  [24] = {.lex_state = 29},
  [25] = {.lex_state = 32},
  [26] = {.lex_state = 35},
  [27] = {.lex_state = 36},
  [28] = {.lex_state = 27},
  [29] = {.lex_state = 29},
  [30] = {.lex_state = 20},
  [31] = {.lex_state = 20},
  [32] = {.lex_state = 29},
  [33] = {.lex_state = 20},
  [34] = {.lex_state = 20},
  [35] = {.lex_state = 29},
  [36] = {.lex_state = 32},
  [37] = {.lex_state = 32},
  [38] = {.lex_state = 31},
  [39] = {.lex_state = 27},
  [40] = {.lex_state = 38},
  [41] = {.lex_state = 29},
  [42] = {.lex_state = 33},
  [43] = {.lex_state = 38},
  [44] = {.lex_state = 36},
  [45] = {.lex_state = 20},
  [46] = {.lex_state = 29},
  [47] = {.lex_state = 20},
  [48] = {.lex_state = 32},
  [49] = {.lex_state = 32},
  [50] = {.lex_state = 32},
  [51] = {.lex_state = 29},
  [52] = {.lex_state = 20},
  [53] = {.lex_state = 29},
  [54] = {.lex_state = 39},
  [55] = {.lex_state = 32},
  [56] = {.lex_state = 35},
  [57] = {.lex_state = 27},
  [58] = {.lex_state = 20},
  [59] = {.lex_state = 20},
  [60] = {.lex_state = 20},
  [61] = {.lex_state = 32},
  [62] = {.lex_state = 32},
  [63] = {.lex_state = 29},
  [64] = {.lex_state = 20},
  [65] = {.lex_state = 39},
  [66] = {.lex_state = 29},
  [67] = {.lex_state = 36},
  [68] = {.lex_state = 31},
  [69] = {.lex_state = 32},
  [70] = {.lex_state = 32},
  [71] = {.lex_state = 35},
  [72] = {.lex_state = 20},
  [73] = {.lex_state = 20},
  [74] = {.lex_state = 20},
  [75] = {.lex_state = 36},
  [76] = {.lex_state = 20},
  [77] = {.lex_state = 32},
  [78] = {.lex_state = 32},
  [79] = {.lex_state = 40},
  [80] = {.lex_state = 29},
  [81] = {.lex_state = 36},
  [82] = {.lex_state = 32},
  [83] = {.lex_state = 20},
  [84] = {.lex_state = 32},
  [85] = {.lex_state = 20},
  [86] = {.lex_state = 40},
  [87] = {.lex_state = 36},
  [88] = {.lex_state = 20},
  [89] = {.lex_state = 39},
  [90] = {.lex_state = 31},
  [91] = {.lex_state = 29},
  [92] = {.lex_state = 20},
  [93] = {.lex_state = 39},
  [94] = {.lex_state = 29},
  [95] = {.lex_state = 32},
  [96] = {.lex_state = 20},
  [97] = {.lex_state = 32},
  [98] = {.lex_state = 40},
  [99] = {.lex_state = 31},
  [100] = {.lex_state = 29},
  [101] = {.lex_state = 29},
  [102] = {.lex_state = 20},
  [103] = {.lex_state = 39},
  [104] = {.lex_state = 36},
  [105] = {.lex_state = 32},
  [106] = {.lex_state = 20},
  [107] = {.lex_state = 38},
  [108] = {.lex_state = 32},
  [109] = {.lex_state = 29},
  [110] = {.lex_state = 36},
  [111] = {.lex_state = 39},
  [112] = {.lex_state = 20},
  [113] = {.lex_state = 20},
  [114] = {.lex_state = 32},
  [115] = {.lex_state = 20},
  [116] = {.lex_state = 39},
  [117] = {.lex_state = 32},
  [118] = {.lex_state = 39},
};

static uint16_t ts_parse_table[STATE_COUNT][SYMBOL_COUNT] = {
  [0] = {
    [ts_builtin_sym_end] = ACTIONS(1),
    [sym_integer] = ACTIONS(1),
    [anon_sym_COMMA] = ACTIONS(1),
    [anon_sym_LPAREN] = ACTIONS(1),
    [anon_sym_RPAREN] = ACTIONS(1),
    [anon_sym_DASH_GT] = ACTIONS(1),
    [anon_sym_COLON] = ACTIONS(1),
    [anon_sym_PLUS] = ACTIONS(1),
    [anon_sym_DASH] = ACTIONS(3),
    [anon_sym_STAR] = ACTIONS(1),
    [anon_sym_SLASH] = ACTIONS(1),
    [anon_sym_PERCENT] = ACTIONS(1),
    [anon_sym_let] = ACTIONS(1),
    [anon_sym_EQ] = ACTIONS(3),
    [anon_sym_in] = ACTIONS(1),
    [anon_sym_EQ_GT] = ACTIONS(1),
  },
  [1] = {
    [sym_source_file] = STATE(6),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(10),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(9),
    [anon_sym_let] = ACTIONS(11),
  },
  [2] = {
    [ts_builtin_sym_end] = ACTIONS(13),
    [anon_sym_COMMA] = ACTIONS(13),
    [anon_sym_LPAREN] = ACTIONS(13),
    [anon_sym_RPAREN] = ACTIONS(13),
    [anon_sym_PLUS] = ACTIONS(13),
    [anon_sym_DASH] = ACTIONS(13),
    [anon_sym_STAR] = ACTIONS(13),
    [anon_sym_SLASH] = ACTIONS(13),
    [anon_sym_PERCENT] = ACTIONS(13),
    [anon_sym_in] = ACTIONS(13),
  },
  [3] = {
    [ts_builtin_sym_end] = ACTIONS(15),
    [anon_sym_COMMA] = ACTIONS(15),
    [anon_sym_LPAREN] = ACTIONS(15),
    [anon_sym_RPAREN] = ACTIONS(15),
    [anon_sym_PLUS] = ACTIONS(15),
    [anon_sym_DASH] = ACTIONS(15),
    [anon_sym_STAR] = ACTIONS(15),
    [anon_sym_SLASH] = ACTIONS(15),
    [anon_sym_PERCENT] = ACTIONS(15),
    [anon_sym_in] = ACTIONS(15),
  },
  [4] = {
    [sym_arguments] = STATE(14),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(15),
    [sym_dec_var] = STATE(16),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(18),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(17),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [5] = {
    [sym_dec_var] = STATE(20),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_identifier] = ACTIONS(23),
  },
  [6] = {
    [ts_builtin_sym_end] = ACTIONS(25),
  },
  [7] = {
    [ts_builtin_sym_end] = ACTIONS(27),
    [anon_sym_COMMA] = ACTIONS(27),
    [anon_sym_LPAREN] = ACTIONS(27),
    [anon_sym_RPAREN] = ACTIONS(27),
    [anon_sym_PLUS] = ACTIONS(27),
    [anon_sym_DASH] = ACTIONS(27),
    [anon_sym_STAR] = ACTIONS(27),
    [anon_sym_SLASH] = ACTIONS(27),
    [anon_sym_PERCENT] = ACTIONS(27),
    [anon_sym_in] = ACTIONS(27),
  },
  [8] = {
    [ts_builtin_sym_end] = ACTIONS(29),
    [anon_sym_COMMA] = ACTIONS(29),
    [anon_sym_LPAREN] = ACTIONS(29),
    [anon_sym_RPAREN] = ACTIONS(29),
    [anon_sym_PLUS] = ACTIONS(29),
    [anon_sym_DASH] = ACTIONS(29),
    [anon_sym_STAR] = ACTIONS(29),
    [anon_sym_SLASH] = ACTIONS(29),
    [anon_sym_PERCENT] = ACTIONS(29),
    [anon_sym_in] = ACTIONS(29),
  },
  [9] = {
    [ts_builtin_sym_end] = ACTIONS(31),
    [anon_sym_COMMA] = ACTIONS(31),
    [anon_sym_LPAREN] = ACTIONS(31),
    [anon_sym_RPAREN] = ACTIONS(31),
    [anon_sym_PLUS] = ACTIONS(31),
    [anon_sym_DASH] = ACTIONS(31),
    [anon_sym_STAR] = ACTIONS(31),
    [anon_sym_SLASH] = ACTIONS(31),
    [anon_sym_PERCENT] = ACTIONS(31),
    [anon_sym_in] = ACTIONS(31),
  },
  [10] = {
    [ts_builtin_sym_end] = ACTIONS(33),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(37),
    [anon_sym_DASH] = ACTIONS(37),
    [anon_sym_STAR] = ACTIONS(39),
    [anon_sym_SLASH] = ACTIONS(39),
    [anon_sym_PERCENT] = ACTIONS(39),
  },
  [11] = {
    [anon_sym_COMMA] = ACTIONS(41),
    [anon_sym_LPAREN] = ACTIONS(15),
    [anon_sym_RPAREN] = ACTIONS(41),
    [anon_sym_COLON] = ACTIONS(43),
    [anon_sym_PLUS] = ACTIONS(15),
    [anon_sym_DASH] = ACTIONS(15),
    [anon_sym_STAR] = ACTIONS(15),
    [anon_sym_SLASH] = ACTIONS(15),
    [anon_sym_PERCENT] = ACTIONS(15),
  },
  [12] = {
    [sym_arguments] = STATE(25),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(15),
    [sym_dec_var] = STATE(16),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(18),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(17),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [13] = {
    [sym_dec_var] = STATE(26),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_identifier] = ACTIONS(23),
  },
  [14] = {
    [anon_sym_RPAREN] = ACTIONS(45),
  },
  [15] = {
    [anon_sym_LPAREN] = ACTIONS(29),
    [anon_sym_RPAREN] = ACTIONS(47),
    [anon_sym_PLUS] = ACTIONS(29),
    [anon_sym_DASH] = ACTIONS(29),
    [anon_sym_STAR] = ACTIONS(29),
    [anon_sym_SLASH] = ACTIONS(29),
    [anon_sym_PERCENT] = ACTIONS(29),
  },
  [16] = {
    [anon_sym_COMMA] = ACTIONS(49),
    [anon_sym_RPAREN] = ACTIONS(51),
  },
  [17] = {
    [anon_sym_COMMA] = ACTIONS(53),
    [anon_sym_RPAREN] = ACTIONS(53),
    [anon_sym_EQ] = ACTIONS(53),
  },
  [18] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(55),
    [anon_sym_DASH] = ACTIONS(55),
    [anon_sym_STAR] = ACTIONS(57),
    [anon_sym_SLASH] = ACTIONS(57),
    [anon_sym_PERCENT] = ACTIONS(57),
  },
  [19] = {
    [anon_sym_COLON] = ACTIONS(59),
    [anon_sym_EQ] = ACTIONS(41),
  },
  [20] = {
    [anon_sym_EQ] = ACTIONS(61),
  },
  [21] = {
    [sym_expressions] = STATE(36),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(37),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [22] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(38),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(9),
    [anon_sym_let] = ACTIONS(11),
  },
  [23] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(39),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(9),
    [anon_sym_let] = ACTIONS(11),
  },
  [24] = {
    [sym_type] = STATE(42),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(69),
  },
  [25] = {
    [anon_sym_RPAREN] = ACTIONS(71),
  },
  [26] = {
    [anon_sym_EQ] = ACTIONS(73),
  },
  [27] = {
    [anon_sym_COLON] = ACTIONS(75),
    [anon_sym_EQ_GT] = ACTIONS(77),
  },
  [28] = {
    [ts_builtin_sym_end] = ACTIONS(79),
    [anon_sym_COMMA] = ACTIONS(79),
    [anon_sym_LPAREN] = ACTIONS(79),
    [anon_sym_RPAREN] = ACTIONS(79),
    [anon_sym_PLUS] = ACTIONS(79),
    [anon_sym_DASH] = ACTIONS(79),
    [anon_sym_STAR] = ACTIONS(79),
    [anon_sym_SLASH] = ACTIONS(79),
    [anon_sym_PERCENT] = ACTIONS(79),
    [anon_sym_in] = ACTIONS(79),
  },
  [29] = {
    [sym_arguments] = STATE(49),
    [sym_dec_var] = STATE(16),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_identifier] = ACTIONS(81),
  },
  [30] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(50),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [31] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(39),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [32] = {
    [sym_type] = STATE(42),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(83),
  },
  [33] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(54),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [34] = {
    [sym_arguments] = STATE(55),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(15),
    [sym_dec_var] = STATE(16),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(18),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(17),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [35] = {
    [sym_dec_var] = STATE(56),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_identifier] = ACTIONS(23),
  },
  [36] = {
    [anon_sym_RPAREN] = ACTIONS(89),
  },
  [37] = {
    [anon_sym_COMMA] = ACTIONS(91),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(93),
    [anon_sym_PLUS] = ACTIONS(95),
    [anon_sym_DASH] = ACTIONS(95),
    [anon_sym_STAR] = ACTIONS(97),
    [anon_sym_SLASH] = ACTIONS(97),
    [anon_sym_PERCENT] = ACTIONS(97),
  },
  [38] = {
    [ts_builtin_sym_end] = ACTIONS(99),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(99),
    [anon_sym_DASH] = ACTIONS(99),
    [anon_sym_STAR] = ACTIONS(39),
    [anon_sym_SLASH] = ACTIONS(39),
    [anon_sym_PERCENT] = ACTIONS(39),
  },
  [39] = {
    [ts_builtin_sym_end] = ACTIONS(99),
    [anon_sym_COMMA] = ACTIONS(99),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(99),
    [anon_sym_PLUS] = ACTIONS(99),
    [anon_sym_DASH] = ACTIONS(99),
    [anon_sym_STAR] = ACTIONS(99),
    [anon_sym_SLASH] = ACTIONS(99),
    [anon_sym_PERCENT] = ACTIONS(99),
    [anon_sym_in] = ACTIONS(99),
  },
  [40] = {
    [anon_sym_COMMA] = ACTIONS(101),
    [anon_sym_RPAREN] = ACTIONS(101),
    [anon_sym_EQ] = ACTIONS(103),
    [anon_sym_EQ_GT] = ACTIONS(101),
  },
  [41] = {
    [sym_types] = STATE(61),
    [sym_type] = STATE(62),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(69),
  },
  [42] = {
    [anon_sym_COMMA] = ACTIONS(105),
    [anon_sym_RPAREN] = ACTIONS(105),
    [anon_sym_EQ] = ACTIONS(105),
  },
  [43] = {
    [anon_sym_COMMA] = ACTIONS(107),
    [anon_sym_RPAREN] = ACTIONS(107),
    [anon_sym_EQ] = ACTIONS(109),
    [anon_sym_EQ_GT] = ACTIONS(107),
  },
  [44] = {
    [anon_sym_COLON] = ACTIONS(111),
    [anon_sym_EQ_GT] = ACTIONS(113),
  },
  [45] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(65),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [46] = {
    [sym_type] = STATE(67),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(115),
  },
  [47] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(68),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(9),
    [anon_sym_let] = ACTIONS(11),
  },
  [48] = {
    [anon_sym_COMMA] = ACTIONS(41),
    [anon_sym_RPAREN] = ACTIONS(41),
    [anon_sym_COLON] = ACTIONS(43),
  },
  [49] = {
    [anon_sym_RPAREN] = ACTIONS(117),
  },
  [50] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(99),
    [anon_sym_PLUS] = ACTIONS(99),
    [anon_sym_DASH] = ACTIONS(99),
    [anon_sym_STAR] = ACTIONS(57),
    [anon_sym_SLASH] = ACTIONS(57),
    [anon_sym_PERCENT] = ACTIONS(57),
  },
  [51] = {
    [sym_types] = STATE(69),
    [sym_type] = STATE(62),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(69),
  },
  [52] = {
    [sym_arguments] = STATE(70),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(15),
    [sym_dec_var] = STATE(16),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(18),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(17),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [53] = {
    [sym_dec_var] = STATE(71),
    [sym_just_var] = STATE(17),
    [sym_typed_var] = STATE(17),
    [sym_identifier] = ACTIONS(23),
  },
  [54] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(123),
  },
  [55] = {
    [anon_sym_RPAREN] = ACTIONS(125),
  },
  [56] = {
    [anon_sym_EQ] = ACTIONS(127),
  },
  [57] = {
    [ts_builtin_sym_end] = ACTIONS(129),
    [anon_sym_COMMA] = ACTIONS(129),
    [anon_sym_LPAREN] = ACTIONS(129),
    [anon_sym_RPAREN] = ACTIONS(129),
    [anon_sym_PLUS] = ACTIONS(129),
    [anon_sym_DASH] = ACTIONS(129),
    [anon_sym_STAR] = ACTIONS(129),
    [anon_sym_SLASH] = ACTIONS(129),
    [anon_sym_PERCENT] = ACTIONS(129),
    [anon_sym_in] = ACTIONS(129),
  },
  [58] = {
    [sym_expressions] = STATE(77),
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(37),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [59] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(78),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [60] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(39),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [61] = {
    [anon_sym_RPAREN] = ACTIONS(131),
  },
  [62] = {
    [anon_sym_COMMA] = ACTIONS(133),
    [anon_sym_RPAREN] = ACTIONS(135),
  },
  [63] = {
    [sym_type] = STATE(81),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(115),
  },
  [64] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(82),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [65] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(137),
  },
  [66] = {
    [sym_types] = STATE(84),
    [sym_type] = STATE(62),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(69),
  },
  [67] = {
    [anon_sym_EQ_GT] = ACTIONS(139),
  },
  [68] = {
    [ts_builtin_sym_end] = ACTIONS(141),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(37),
    [anon_sym_DASH] = ACTIONS(37),
    [anon_sym_STAR] = ACTIONS(39),
    [anon_sym_SLASH] = ACTIONS(39),
    [anon_sym_PERCENT] = ACTIONS(39),
  },
  [69] = {
    [anon_sym_RPAREN] = ACTIONS(143),
  },
  [70] = {
    [anon_sym_RPAREN] = ACTIONS(145),
  },
  [71] = {
    [anon_sym_EQ] = ACTIONS(147),
  },
  [72] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(89),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [73] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(39),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [74] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(90),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(9),
    [anon_sym_let] = ACTIONS(11),
  },
  [75] = {
    [anon_sym_COLON] = ACTIONS(149),
    [anon_sym_EQ_GT] = ACTIONS(151),
  },
  [76] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(93),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [77] = {
    [anon_sym_RPAREN] = ACTIONS(153),
  },
  [78] = {
    [anon_sym_COMMA] = ACTIONS(99),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(99),
    [anon_sym_PLUS] = ACTIONS(99),
    [anon_sym_DASH] = ACTIONS(99),
    [anon_sym_STAR] = ACTIONS(97),
    [anon_sym_SLASH] = ACTIONS(97),
    [anon_sym_PERCENT] = ACTIONS(97),
  },
  [79] = {
    [anon_sym_DASH_GT] = ACTIONS(155),
  },
  [80] = {
    [sym_types] = STATE(95),
    [sym_type] = STATE(62),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(69),
  },
  [81] = {
    [anon_sym_EQ_GT] = ACTIONS(157),
  },
  [82] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(141),
    [anon_sym_PLUS] = ACTIONS(55),
    [anon_sym_DASH] = ACTIONS(55),
    [anon_sym_STAR] = ACTIONS(57),
    [anon_sym_SLASH] = ACTIONS(57),
    [anon_sym_PERCENT] = ACTIONS(57),
  },
  [83] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(97),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [84] = {
    [anon_sym_RPAREN] = ACTIONS(159),
  },
  [85] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(99),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(9),
    [anon_sym_let] = ACTIONS(11),
  },
  [86] = {
    [anon_sym_DASH_GT] = ACTIONS(161),
  },
  [87] = {
    [anon_sym_COLON] = ACTIONS(163),
    [anon_sym_EQ_GT] = ACTIONS(165),
  },
  [88] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(103),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [89] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(99),
    [anon_sym_DASH] = ACTIONS(99),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(99),
  },
  [90] = {
    [ts_builtin_sym_end] = ACTIONS(167),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(37),
    [anon_sym_DASH] = ACTIONS(37),
    [anon_sym_STAR] = ACTIONS(39),
    [anon_sym_SLASH] = ACTIONS(39),
    [anon_sym_PERCENT] = ACTIONS(39),
  },
  [91] = {
    [sym_type] = STATE(104),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(115),
  },
  [92] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(105),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [93] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(169),
  },
  [94] = {
    [sym_type] = STATE(107),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(69),
  },
  [95] = {
    [anon_sym_RPAREN] = ACTIONS(171),
  },
  [96] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(108),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(19),
    [anon_sym_let] = ACTIONS(21),
  },
  [97] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(167),
    [anon_sym_PLUS] = ACTIONS(55),
    [anon_sym_DASH] = ACTIONS(55),
    [anon_sym_STAR] = ACTIONS(57),
    [anon_sym_SLASH] = ACTIONS(57),
    [anon_sym_PERCENT] = ACTIONS(57),
  },
  [98] = {
    [anon_sym_DASH_GT] = ACTIONS(173),
  },
  [99] = {
    [ts_builtin_sym_end] = ACTIONS(175),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(37),
    [anon_sym_DASH] = ACTIONS(37),
    [anon_sym_STAR] = ACTIONS(39),
    [anon_sym_SLASH] = ACTIONS(39),
    [anon_sym_PERCENT] = ACTIONS(39),
  },
  [100] = {
    [sym_type] = STATE(107),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(83),
  },
  [101] = {
    [sym_type] = STATE(110),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(115),
  },
  [102] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(111),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [103] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(177),
  },
  [104] = {
    [anon_sym_EQ_GT] = ACTIONS(179),
  },
  [105] = {
    [anon_sym_COMMA] = ACTIONS(141),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(141),
    [anon_sym_PLUS] = ACTIONS(95),
    [anon_sym_DASH] = ACTIONS(95),
    [anon_sym_STAR] = ACTIONS(97),
    [anon_sym_SLASH] = ACTIONS(97),
    [anon_sym_PERCENT] = ACTIONS(97),
  },
  [106] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(114),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [107] = {
    [anon_sym_COMMA] = ACTIONS(181),
    [anon_sym_RPAREN] = ACTIONS(181),
    [anon_sym_EQ] = ACTIONS(183),
    [anon_sym_EQ_GT] = ACTIONS(181),
  },
  [108] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(175),
    [anon_sym_PLUS] = ACTIONS(55),
    [anon_sym_DASH] = ACTIONS(55),
    [anon_sym_STAR] = ACTIONS(57),
    [anon_sym_SLASH] = ACTIONS(57),
    [anon_sym_PERCENT] = ACTIONS(57),
  },
  [109] = {
    [sym_type] = STATE(107),
    [sym_unit_type] = STATE(43),
    [sym_function_type] = STATE(43),
    [sym_identifier] = ACTIONS(67),
    [anon_sym_LPAREN] = ACTIONS(115),
  },
  [110] = {
    [anon_sym_EQ_GT] = ACTIONS(185),
  },
  [111] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(141),
  },
  [112] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(116),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [113] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(117),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(63),
    [anon_sym_let] = ACTIONS(65),
  },
  [114] = {
    [anon_sym_COMMA] = ACTIONS(167),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(167),
    [anon_sym_PLUS] = ACTIONS(95),
    [anon_sym_DASH] = ACTIONS(95),
    [anon_sym_STAR] = ACTIONS(97),
    [anon_sym_SLASH] = ACTIONS(97),
    [anon_sym_PERCENT] = ACTIONS(97),
  },
  [115] = {
    [sym_paren_expr] = STATE(7),
    [sym_unit_expr] = STATE(8),
    [sym_compound_expr] = STATE(8),
    [sym_expr_int] = STATE(7),
    [sym_expr_var] = STATE(7),
    [sym_expr_bin_op] = STATE(9),
    [sym_expr_let] = STATE(9),
    [sym_expr_function] = STATE(9),
    [sym_expr_application] = STATE(9),
    [sym_expr] = STATE(118),
    [sym_integer] = ACTIONS(5),
    [sym_identifier] = ACTIONS(7),
    [anon_sym_LPAREN] = ACTIONS(85),
    [anon_sym_let] = ACTIONS(87),
  },
  [116] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(167),
  },
  [117] = {
    [anon_sym_COMMA] = ACTIONS(175),
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_RPAREN] = ACTIONS(175),
    [anon_sym_PLUS] = ACTIONS(95),
    [anon_sym_DASH] = ACTIONS(95),
    [anon_sym_STAR] = ACTIONS(97),
    [anon_sym_SLASH] = ACTIONS(97),
    [anon_sym_PERCENT] = ACTIONS(97),
  },
  [118] = {
    [anon_sym_LPAREN] = ACTIONS(35),
    [anon_sym_PLUS] = ACTIONS(119),
    [anon_sym_DASH] = ACTIONS(119),
    [anon_sym_STAR] = ACTIONS(121),
    [anon_sym_SLASH] = ACTIONS(121),
    [anon_sym_PERCENT] = ACTIONS(121),
    [anon_sym_in] = ACTIONS(175),
  },
};

static TSParseActionEntry ts_parse_actions[] = {
  [0] = {.count = 0, .reusable = false},
  [1] = {.count = 1, .reusable = true}, RECOVER(),
  [3] = {.count = 1, .reusable = false}, RECOVER(),
  [5] = {.count = 1, .reusable = true}, SHIFT(2),
  [7] = {.count = 1, .reusable = false}, SHIFT(3),
  [9] = {.count = 1, .reusable = true}, SHIFT(4),
  [11] = {.count = 1, .reusable = false}, SHIFT(5),
  [13] = {.count = 1, .reusable = true}, REDUCE(sym_expr_int, 1),
  [15] = {.count = 1, .reusable = true}, REDUCE(sym_expr_var, 1),
  [17] = {.count = 1, .reusable = false}, SHIFT(11),
  [19] = {.count = 1, .reusable = true}, SHIFT(12),
  [21] = {.count = 1, .reusable = false}, SHIFT(13),
  [23] = {.count = 1, .reusable = true}, SHIFT(19),
  [25] = {.count = 1, .reusable = true}, ACCEPT_INPUT(),
  [27] = {.count = 1, .reusable = true}, REDUCE(sym_unit_expr, 1),
  [29] = {.count = 1, .reusable = true}, REDUCE(sym_expr, 1),
  [31] = {.count = 1, .reusable = true}, REDUCE(sym_compound_expr, 1),
  [33] = {.count = 1, .reusable = true}, REDUCE(sym_source_file, 1),
  [35] = {.count = 1, .reusable = true}, SHIFT(21),
  [37] = {.count = 1, .reusable = true}, SHIFT(22),
  [39] = {.count = 1, .reusable = true}, SHIFT(23),
  [41] = {.count = 1, .reusable = true}, REDUCE(sym_just_var, 1),
  [43] = {.count = 1, .reusable = true}, SHIFT(24),
  [45] = {.count = 1, .reusable = true}, SHIFT(27),
  [47] = {.count = 1, .reusable = true}, SHIFT(28),
  [49] = {.count = 1, .reusable = true}, SHIFT(29),
  [51] = {.count = 1, .reusable = true}, REDUCE(sym_arguments, 1),
  [53] = {.count = 1, .reusable = true}, REDUCE(sym_dec_var, 1),
  [55] = {.count = 1, .reusable = true}, SHIFT(30),
  [57] = {.count = 1, .reusable = true}, SHIFT(31),
  [59] = {.count = 1, .reusable = true}, SHIFT(32),
  [61] = {.count = 1, .reusable = true}, SHIFT(33),
  [63] = {.count = 1, .reusable = true}, SHIFT(34),
  [65] = {.count = 1, .reusable = false}, SHIFT(35),
  [67] = {.count = 1, .reusable = true}, SHIFT(40),
  [69] = {.count = 1, .reusable = true}, SHIFT(41),
  [71] = {.count = 1, .reusable = true}, SHIFT(44),
  [73] = {.count = 1, .reusable = true}, SHIFT(45),
  [75] = {.count = 1, .reusable = true}, SHIFT(46),
  [77] = {.count = 1, .reusable = true}, SHIFT(47),
  [79] = {.count = 1, .reusable = true}, REDUCE(sym_paren_expr, 3),
  [81] = {.count = 1, .reusable = true}, SHIFT(48),
  [83] = {.count = 1, .reusable = true}, SHIFT(51),
  [85] = {.count = 1, .reusable = true}, SHIFT(52),
  [87] = {.count = 1, .reusable = false}, SHIFT(53),
  [89] = {.count = 1, .reusable = true}, SHIFT(57),
  [91] = {.count = 1, .reusable = true}, SHIFT(58),
  [93] = {.count = 1, .reusable = true}, REDUCE(sym_expressions, 1),
  [95] = {.count = 1, .reusable = true}, SHIFT(59),
  [97] = {.count = 1, .reusable = true}, SHIFT(60),
  [99] = {.count = 1, .reusable = true}, REDUCE(sym_expr_bin_op, 3),
  [101] = {.count = 1, .reusable = true}, REDUCE(sym_unit_type, 1),
  [103] = {.count = 1, .reusable = false}, REDUCE(sym_unit_type, 1),
  [105] = {.count = 1, .reusable = true}, REDUCE(sym_typed_var, 3),
  [107] = {.count = 1, .reusable = true}, REDUCE(sym_type, 1),
  [109] = {.count = 1, .reusable = false}, REDUCE(sym_type, 1),
  [111] = {.count = 1, .reusable = true}, SHIFT(63),
  [113] = {.count = 1, .reusable = true}, SHIFT(64),
  [115] = {.count = 1, .reusable = true}, SHIFT(66),
  [117] = {.count = 1, .reusable = true}, REDUCE(sym_arguments, 3),
  [119] = {.count = 1, .reusable = true}, SHIFT(72),
  [121] = {.count = 1, .reusable = true}, SHIFT(73),
  [123] = {.count = 1, .reusable = true}, SHIFT(74),
  [125] = {.count = 1, .reusable = true}, SHIFT(75),
  [127] = {.count = 1, .reusable = true}, SHIFT(76),
  [129] = {.count = 1, .reusable = true}, REDUCE(sym_expr_application, 4),
  [131] = {.count = 1, .reusable = true}, SHIFT(79),
  [133] = {.count = 1, .reusable = true}, SHIFT(80),
  [135] = {.count = 1, .reusable = true}, REDUCE(sym_types, 1),
  [137] = {.count = 1, .reusable = true}, SHIFT(83),
  [139] = {.count = 1, .reusable = true}, SHIFT(85),
  [141] = {.count = 1, .reusable = true}, REDUCE(sym_expr_function, 5),
  [143] = {.count = 1, .reusable = true}, SHIFT(86),
  [145] = {.count = 1, .reusable = true}, SHIFT(87),
  [147] = {.count = 1, .reusable = true}, SHIFT(88),
  [149] = {.count = 1, .reusable = true}, SHIFT(91),
  [151] = {.count = 1, .reusable = true}, SHIFT(92),
  [153] = {.count = 1, .reusable = true}, REDUCE(sym_expressions, 3),
  [155] = {.count = 1, .reusable = true}, SHIFT(94),
  [157] = {.count = 1, .reusable = true}, SHIFT(96),
  [159] = {.count = 1, .reusable = true}, SHIFT(98),
  [161] = {.count = 1, .reusable = true}, SHIFT(100),
  [163] = {.count = 1, .reusable = true}, SHIFT(101),
  [165] = {.count = 1, .reusable = true}, SHIFT(102),
  [167] = {.count = 1, .reusable = true}, REDUCE(sym_expr_let, 6),
  [169] = {.count = 1, .reusable = true}, SHIFT(106),
  [171] = {.count = 1, .reusable = true}, REDUCE(sym_types, 3),
  [173] = {.count = 1, .reusable = true}, SHIFT(109),
  [175] = {.count = 1, .reusable = true}, REDUCE(sym_expr_function, 7),
  [177] = {.count = 1, .reusable = true}, SHIFT(112),
  [179] = {.count = 1, .reusable = true}, SHIFT(113),
  [181] = {.count = 1, .reusable = true}, REDUCE(sym_function_type, 5),
  [183] = {.count = 1, .reusable = false}, REDUCE(sym_function_type, 5),
  [185] = {.count = 1, .reusable = true}, SHIFT(115),
};

#ifdef _WIN32
#define extern __declspec(dllexport)
#endif

extern const TSLanguage *tree_sitter_menhera() {
  static TSLanguage language = {
    .version = LANGUAGE_VERSION,
    .symbol_count = SYMBOL_COUNT,
    .alias_count = ALIAS_COUNT,
    .token_count = TOKEN_COUNT,
    .symbol_metadata = ts_symbol_metadata,
    .parse_table = (const unsigned short *)ts_parse_table,
    .parse_actions = ts_parse_actions,
    .lex_modes = ts_lex_modes,
    .symbol_names = ts_symbol_names,
    .max_alias_sequence_length = MAX_ALIAS_SEQUENCE_LENGTH,
    .lex_fn = ts_lex,
    .external_token_count = EXTERNAL_TOKEN_COUNT,
  };
  return &language;
}
