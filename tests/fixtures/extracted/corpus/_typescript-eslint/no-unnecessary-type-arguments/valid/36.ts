
import { F } from './missing';
function bar<T = F>() {}
bar<F<number>>();
    