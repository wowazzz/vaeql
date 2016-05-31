#include "hphp/runtime/ext/extension.h"

namespace HPHP {

  class VaeqlExtension : public Extension {
     public:
         VaeqlExtension(): Extension("vaeql", "1.0") {}
  } s_vaeql_extension;

  HHVM_GET_MODULE(vaeql);

} // namespace HPHP
