[% IF !estadoDeColeccion %]
	[% IF nav_elements %]
		<div class="side_bar nano">
			<ul class="nav nav-tabs nav-stacked content">
				[% FOREACH elem IN nav_elements %]
			        	<li><a href="#[% elem.id %]">[% elem.title %]</a></li>
			    [% END %]
			</ul>
		</div>
	[% END %]
[% END %]