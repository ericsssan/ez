
import { Enum } from "module-that-does't-exist";

declare module "module-that-doesn't-exist" {
  enum Enum {
    StringLike = 'StringLike',
  }
}
    