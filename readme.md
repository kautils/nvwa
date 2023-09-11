### nvwa
* adjusted nvwa so that it can be used with mingw.
* use mmanp-win32 internally
* [nvwa.git](https://github.com/adah1972/nvwa.git)
* [detail of nvwa](http://wyw.dcweb.cn/leakage.htm)

### exmaple 
```c++
#include "nvmw/debug_new.h"
#include <stdio.h>
struct some{};
int main(){
    auto a = new int(100);
    delete a;
    new some();
    return 0;
}
```
