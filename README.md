Erubis Cached Text: All ur HTML are belong 2 MEMRY
==================================================

What is it?
-----------

It's an Eruby engine (using Erubis) that caches static text in memory instead
of instantiating these String objects every time the Eruby template is rendered.
Basically, this means a bit more memory is consumed by your Ruby process, but
rendering time is reduced (and how!).

How much faster is it?
----------------------

This depends entirely on how much static text you have in your templates. If
your template is entirely code, it won't save you any time at all. However,
for templates with lots of static text (such as HTML, JavaScript, etc), the
speed difference is quite substantial. I plan on benchmarking it a lot more
in the near future, but right now I just have a 600 line HTML template with a
few lines of code and in THIS situation it's 3x faster than normal Erubis
rendering.

Also, less allocations means less time spent in GC :)

How can I use it?
-----------------

    gem 'erubis-cached-text'
    require 'erubis_cached_text'

The rest is the same, just use the class Erubis::ErubyCachedText instead of
the engine you used to use (such as Erubis::Eruby).

How can I use it with Rails?
----------------------------

I'll be coming out with a gem soon for use with Rails.
