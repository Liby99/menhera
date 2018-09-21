import _ from 'underscore';
import MhrType, { MhrUnitType, MhrClosureType } from 'core/mhrType';

export type Env = {
  [name: string]: MhrType,
};

export type Context = {
  next: number,
  env: Env,
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
      const argsSubsts = closT1.args.reduce((argsSubsts, arg, argIndex) => ({
        ...argsSubsts,
        ...unify(arg, closT2.args[argIndex])
      }), {});
      return { ...retSubst, ...argsSubsts };
    }
  } else if (t1.type === 'temp' || t2.type === 'temp') {
    
    // If any of them is temporary type
    
  }
}