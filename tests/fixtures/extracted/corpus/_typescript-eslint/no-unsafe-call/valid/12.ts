
interface SafeWithNonVoidCallSignature extends Function {
  (): void;
  (x: string): string;
}
declare const safe: SafeWithNonVoidCallSignature;
safe();
    