local Types = {}

export type Array<V> = { [number]: V }
export type Dictionary<V> = { [string]: V }
export type Function<P..., R...> = (P...) -> R...
export type Mapping<K, V> = { [K]: V }
export type Table = Array<any> | Mapping<any, any>

return Types
