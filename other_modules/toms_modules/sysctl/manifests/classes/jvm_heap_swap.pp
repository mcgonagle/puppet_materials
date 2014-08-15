class sysctl::jvm_heap_size inherits sysctl {

   sysctl::conf{ "$name":
	"vm.swappiness": value => 0;

	"net.core.rmem_max": value => 16777216;
	"net.core.wmem_max": value => 16777216;

}
