const PREC = {
  LET: 0,
  PLUS_MINUS: 1,
  MULT_DIV_MOD: 2,
  APPLICATION: 3,
};

module.exports = grammar({
  name: 'menhera',
  rules: {
    
    // Entry point
    source_file: $ => $.expr,
    
    // Statics
    integer: $ => /\-?\d+/,
    identifier: $ => /[a-zA-Z\_][a-zA-Z0-9\_]+/,
    
    // Helpers
    arguments: $ => seq($.dec_var, optional(seq(',', $.arguments))),
    expressions: $ => seq($.expr, optional(seq(',', $.expressions))),
    types: $ => seq($.type, optional(seq(',', $.types))),
    paren_expr: $ => seq('(', $.compound_expr, ')'),
    unit_expr: $ => choice(
      $.expr_int,
      $.expr_var,
      $.paren_expr
    ),
    compound_expr: $ => choice(
      $.expr_bin_op,
      $.expr_let,
      $.expr_function,
      $.expr_application
    ),
    
    // Type
    type: $ => choice($.unit_type, $.function_type),
    unit_type: $ => $.identifier,
    function_type: $ => seq('(', $.types, ')', '->', $.type),
    
    // Var Declarations
    dec_var: $ => choice($.just_var, $.typed_var),
    just_var: $ => $.identifier,
    typed_var: $ => seq($.identifier, ':', $.type),
    
    // Expressions
    expr_int: $ => $.integer,
    expr_var: $ => $.identifier,
    expr_bin_op: $ => choice(
      prec.left(PREC.PLUS_MINUS, seq($.expr, '+', $.expr)),
      prec.left(PREC.PLUS_MINUS, seq($.expr, '-', $.expr)),
      prec.left(PREC.MULT_DIV_MOD, seq($.expr, '*', $.expr)),
      prec.left(PREC.MULT_DIV_MOD, seq($.expr, '/', $.expr)),
      prec.left(PREC.MULT_DIV_MOD, seq($.expr, '%', $.expr)),
    ),
    expr_let: $ => seq('let', $.dec_var, '=', $.expr, 'in', $.expr),
    expr_function: $ => prec.right(seq(
      '(',
      $.arguments,
      ')',
      optional(seq(':', $.type)),
      '=>',
      $.expr
    )),
    expr_application: $ => prec.left(
      PREC.APPLICATION,
      seq(
        $.expr,
        '(',
        $.expressions,
        ')'
      )
    ),
    expr: $ => choice($.unit_expr, $.compound_expr),
  }
});
