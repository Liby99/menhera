const fs = require("fs");

function match (c, options) {
    options[c.id].apply(c.getArgs());
}

class Case {
    constructor (id, args) {
        this.id = id;
        this.args = args;
    }
}

function to_token_list (str) {
    return str
        .split(/\s/)
        .filter(s => s != '')
        .map(s => s.split(/([\+\-\*\/\(\)\,\.])/g))
        .reduce((acc, curr) => acc.concat(curr), [])
        .filter(s => s != '');
}

function to_sexp_let (ls, i) {
    switch (ls[i + 1]) {
        case "=":
        default: throw "Invalid let syntax";
    }
}

function to_sexp_body (ls, i) {
    if (i < ls.length) {
        switch (ls[i]) {
            case "let": return "(let (" + to_sexp_let(ls, i + 1) + ")";
        }
    }
    else {
        return "";
    }
}

function parseExpr (c) {
    match(c, {
        "app": function (func_name, args) {
            
        },
        "prim2": function (type, e1, e2) {
            parseExpr(e1) + parseExpr(e2);
        }
    });
}

function parse (str) {
    var ls = to_token_list(str);
    var ast = to_sexp_body(ls, 0);
}

function parseFile (file) {
    var str = fs.readFileSync(file, "utf8");
    return parse(str);
}

console.log(parseFile(process.argv[2]));
