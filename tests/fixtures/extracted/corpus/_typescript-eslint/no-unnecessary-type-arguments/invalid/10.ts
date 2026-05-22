
import { F } from './missing';
function bar<T = F<string>>() {}
bar<F<string>>();
      