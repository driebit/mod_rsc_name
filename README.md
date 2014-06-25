mod_rsc_name
============

Zotonic module for automatically assigning unique names to resources.

This module hooks into the update notification of `m_rsc` to
automatically assign a unique name to each resource when the
resource's unique `name` property is still empty.

The name that is generated is based on the title attribute of the
resource. When multiple resources have the same title, a sequence
number is appended to the name to enforce the unique constraint.

Note that the resource's name does not change when the title of the
resource changes -- once a name is assigned, it stays the same until
the name is explicitly cleared in the admin interface, at which point
a new unique name is generated based on the resource's title.
