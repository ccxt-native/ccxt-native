export const isArray = (paramType: string): boolean => paramType.includes('[]') || paramType === 'Strings';

export function capitalize (methodName: string) {
    return methodName.charAt(0).toUpperCase() + methodName.slice(1);
}

export function lowercaseFirstLetter(str: string): string {
    return str[0].toLowerCase() + str.slice(1);
}

export const prefixWith = (arr: string[], sep: string) => arr.length > 0 ? sep : '';
