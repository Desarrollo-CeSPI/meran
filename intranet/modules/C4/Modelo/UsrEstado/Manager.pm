package C4::Modelo::UsrEstado::Manager;

# this class IS a "Rose::DB::Object::Manager"
# and contains all the methodes that 
# Rose::DB::Object::Manager does
use base qw(Rose::DB::Object::Manager);

# replace the inherited Products->object_class
# with our own new Product->object_class
# (yes, it just always returns the value 'Product')
sub object_class { 'C4::Modelo::UsrEstado' }

# use the make_manager_methods to generate methodes 
# to manage the objects, the methods are called:
#
#    get_usr_estado
#    get_usr_estadp_iterator
#    get_usr_estado_count
#    delete_usr_estado
#    update_usr_estado
#
__PACKAGE__->make_manager_methods('usr_estado');

1;
