export type Property = {name: string, defaultValue: string | undefined, type: string, hasGetter: boolean, hasSetter: boolean};
export type Properties = {[key: string]: Property};
export type MethodTranspiler = (methodName: string, params: {[key: string]: [string, string | null]}, returnType: string, isAsync: boolean) => string;
export type PropertyTranspiler = (prop: Property) => string;
export type StringDict = { [key: string]: string };
export type MethodHeader = {methodName: string, paramDict: {[key: string]: [string, string | null]}, returnType: string, isAsync: boolean};