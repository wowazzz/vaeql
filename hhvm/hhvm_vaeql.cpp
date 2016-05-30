#include "hphp/runtime/base/base-includes.h"

namespace HPHP {

  class VaeqlExtension : public Extension {
     public:
         VaeqlExtension(): Extension("vaeql", "1.0") {}
  } s_example1_extension;

  HHVM_GET_MODULE(vaeql);

} // namespace HPHP
