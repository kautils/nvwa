### nvwa
* adjusted nvwa so that it can be used with mingw.
* use mmanp-win32 internally
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
