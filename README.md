mod_rsc_name
============

Zotonic module for automatically assigning unique names to resources

This module hooks into the update notification of `m_rsc` to
automatically assign a unique name to each resource when the
resource's unique `name` property is still empty.

The name that is generated is based on the title attribute of the
resource. When multiple resources have the same title, a sequence
number is appended to the name to enforce the unique constraint.
