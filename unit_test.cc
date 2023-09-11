

#include "debug_new.h"
//#include "nvwa/debug_new.h"
#include <stdio.h>

struct some{};
int main(){
    auto a = new int(100);
    delete a;
    new some();
    return 0;
}