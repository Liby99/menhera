import * as _ from 'underscore';
import MhrNode, { MhrVarNode, MhrLetNode, MhrBinOpNode, MhrFunctionNode, MhrApplicationNode } from 'core/mhrNode';
import MhrType, { MhrUnitType, MhrClosureType, MhrTempType } from 'core/mhrType';
import MhrAst from 'core/mhrAst';
import MhrVar from 'core/mhrVar';

export type Env = {
  [name: string]: MhrType,
};

export type Substitution = {
  [key: string]: MhrType,
};

export function unify(t1: MhrType, t2: MhrType): Substitution {
  if (t1.type === 'unit' && t2.type === 'unit') {

    // If both are unit types
    const unitT1 = <MhrUnitType> t1;
    const unitT2 = <MhrUnitType> t2;
    if (unitT1.name === unitT2.name) {
      return {};
    } else {
      throw new Error(`Type mismatch: Expected ${unitT1}, But Found ${unitT2}`);
    }
  } else if (t1.type === 'closure' && t2.type === 'closure') {

    // If both are closure types
    const closT1 = <MhrClosureType> t1;
    const closT2 = <MhrClosureType> t2;
    const retSubst = unify(closT1.ret, closT2.ret);
    if (closT1.args.length !== closT2.args.length) {

      // Check if the argument length different
      throw new Error(`Argument length mismatch in ${closT1} and ${closT2}`);
    } else {

      // Get all unified substitutions in args
      return closT1.args.reduce(
        (argsSubsts, arg, argIndex) => composeSubst(
          argsSubsts,
          unify(arg, closT2.args[argIndex])
        ),
        retSubst
      );
    }
  } else if (t1.type === 'temp' || t2.type === 'temp') {

    // If any of them is temporary type
    if (t1.type === 'temp') {
      const { id } = <MhrTempType> t1;
      return varBind(id, t2);
    } else {
      const { id } = <MhrTempType> t2;
      return varBind(id, t1);
    }
  } else {

    // ...
    throw new Error(`Type mismatch: Expected ${t1}, But found ${t2}`);
  }
}

export function applySubstToType(subst: Substitution, type: MhrType): MhrType {
  return type.match({
    'unit': () => type,
    'temp': ({ id }: MhrTempType) => (subst[id] && applySubstToType(subst, subst[id])) || type,
    'closure': ({ ret, args }: MhrClosureType) => new MhrClosureType(
      applySubstToType(subst, ret),
      args.map(arg => applySubstToType(subst, arg))
    ),
  });
}

export function composeSubst(s1: Substitution, s2: Substitution): Substitution {
  const result = Object.keys(s2).reduce((result, k) => ({
    ...result,
    [k]: applySubstToType(s1, s2[k]),
  }), {});
  return { ...s1, ...result };
}

export function varBind(id: number, t: MhrType): Substitution {
  if (t.type === 'temp') {
    const tempT = <MhrTempType> t;
    return id === tempT.id ? {} : { [id]: t };
  } else if (contains(t, id)) {
    throw new Error(`Type ${t} contains a reference to itself`);
  } else {
    return { [id]: t };
  }
}

export function contains(t: MhrType, id: number): boolean {
  return t.match({
    'unit': () => false,
    'temp': (t: MhrTempType) => t.id === id,
    'closure': ({ ret, args }: MhrClosureType) => args.reduce((cts, arg) => cts || contains(arg, id), contains(ret, id))
  });
}

export function applySubstToEnv(subst: Substitution, env: Env): Env {
  return Object.keys(env).reduce((newEnv, name) => _.extend(newEnv, {
    [name]: applySubstToType(subst, env[name])
  }), {});
}

export function infer(env: Env, node: MhrNode): { type: MhrType, substs: Substitution } {
  const { type, substs } = node.match({
    'int': () => ({
      type: new MhrUnitType('int'),
      substs: {}
    }),
    'var': ({ name }: MhrVarNode) => {
      if (env[name]) {
        return {
          type: env[name],
          substs: {}
        };
      } else {
        throw new Error(`Unbound variable ${name}`);
      }
    },
    'bin_op': (node: MhrBinOpNode) => {

      const plusMinusMult = ({ e1, e2 }: MhrBinOpNode) => {
        const { type: e1Type, substs: s1 } = infer(env, e1);
        const { type: e2Type, substs: s2 } = infer(env, e2);
        const s1p = composeSubst(s1, unify(e1Type, new MhrUnitType('int')));
        const s2p = composeSubst(s2, unify(e2Type, new MhrUnitType('int')));
        return { type: new MhrUnitType('int'), substs: composeSubst(s1p, s2p) };
      }

      return node.matchOperator({
        '+': plusMinusMult,
        '-': plusMinusMult,
        '*': plusMinusMult,
      });
    },
    'let': ({ variable, binding, expr }: MhrLetNode) => {
      const { type: bindingType, substs: s1 } = infer(env, binding);
      variable.type = bindingType;
      const newEnv = { ...env, [variable.name]: variable.type };
      const { type: exprType, substs: s2 } = infer(newEnv, expr);
      const finalSubsts = composeSubst(s1, s2);
      return { type: exprType, substs: finalSubsts };
    },
    'function': ({ args, retType, body }: MhrFunctionNode) => {
      const newEnv = args.reduce((newEnv, arg) => ({ ...newEnv, [arg.name]: arg.type }), env);
      const { type: bodyType, substs } = infer(newEnv, body);
      const finalSubsts = composeSubst(substs, unify(retType, bodyType));
      return {
        type: new MhrClosureType(
          applySubstToType(finalSubsts, bodyType),
          args.map((arg) => applySubstToType(finalSubsts, arg.type))
        ),
        substs: finalSubsts
      };
    },
    'application': ({ callee, params }: MhrApplicationNode) => {
      const { type: calleeType, substs: s1 } = infer(env, callee);
      const { paramTypes, substs: paramSubsts } = params.reduce(({ paramTypes, substs }, param) => {
        const { type: paramType, substs: paramSubsts } = infer(applySubstToEnv(s1, env), param);
        return {
          paramTypes: paramTypes.concat(paramType),
          substs: composeSubst(substs, paramSubsts),
        };
      }, { paramTypes: [], substs: s1 });
      const selfSubst = unify(new MhrClosureType(node.mhrType, paramTypes), calleeType);
      const funcType1 = <MhrClosureType> applySubstToType(selfSubst, calleeType);
      const funcSubst = composeSubst(paramSubsts, selfSubst);
      const resultSubst = paramTypes.reduce((substs, paramType, paramIndex) => composeSubst(
        substs,
        unify(applySubstToType(funcSubst, funcType1.args[paramIndex]), paramType),
      ), funcSubst);
      return {
        type: applySubstToType(resultSubst, funcType1.ret),
        substs: resultSubst
      };
    }
  });
  node.setMhrType(type);
  return { type, substs };
}

export function applySubstToAst(substs: Substitution, ast: MhrAst): MhrAst {
  const traverse = (node: MhrNode) => node.match({
    'int': () => node,
    'var': ({ name, mhrType }: MhrVarNode) => new MhrVarNode({ name }, applySubstToType(substs, mhrType)),
    'let': ({ variable: { name, type }, binding, expr, mhrType }: MhrLetNode) => new MhrLetNode({
      variable: new MhrVar(name, applySubstToType(substs, type)),
      binding: traverse(binding),
      expr: traverse(expr),
    }, applySubstToType(substs, mhrType)),
    'bin_op': ({ op, e1, e2, mhrType }: MhrBinOpNode) => new MhrBinOpNode({
      op,
      e1: traverse(e1),
      e2: traverse(e2),
    }, applySubstToType(substs, mhrType)),
    'function': ({ args, retType, body, mhrType }: MhrFunctionNode) => new MhrFunctionNode({
      args: args.map(({ name, type }) => new MhrVar(name, applySubstToType(substs, type))),
      retType: applySubstToType(substs, retType),
      body: traverse(body),
    }, applySubstToType(substs, mhrType)),
    'application': ({ callee, params, mhrType }: MhrApplicationNode) => new MhrApplicationNode({
      callee: traverse(callee),
      params: params.map((param) => traverse(param)),
    }, applySubstToType(substs, mhrType)),
  });
  return new MhrAst(traverse(ast.rootNode));
}