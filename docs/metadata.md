# EIDF Metadata Information

## What is FAIR?

FAIR stands for Findable, Accessible, Interoperable, and Reusable, and helps emphasise the best practices with publishing and sharing data (more details: https://www.go-fair.org/fair-principles/)

## What is metadata?

Metadata is data about data, to help describe the dataset. Common metadata fields are things like the title of the dataset, who produced it, where it was generated (if relevant), when it was generated, and some key words describing it

## What is CKAN?

CKAN is a metadata catalogue - i.e. it is a database for metadata rather than data. This will help with all aspects of FAIR:

 - it will be a signposting portal for where the data actually resides
 - it will ensure that at least metadata (even if not the data) is in a format which is easily retrievable via an identifier 
 - the metadata (and hopefully data) use terms from vocabularies that are widely recognised in the relevant field
 - the metadata has lots of attributes to help others use it, and there are clear licence conditions where necessary

## What metadata will we need to provide?

 - the title of the dataset; if a short title is not particularly descriptive, then please add a longer, separate, description too.
 - the name of the person who created the dataset
 - if it has spatial relevance, the latitude and longitude of the location where the dataset was generated, if possible (e.g. if a sensor has collected data, then it should be straightforward to know the lat and long)
 - the temporal period that the dataset covers
 - it is important to standardise the licencing for all data and we will use https://creativecommons.org/licenses/by-sa/4.0/ by default. If you want a different licence, please come and talk to us. 
 - If the dataset is from a third party, you _must_ tell us the licence of that dataset
 - As well as the theme you've picked for your WP directory, you can add other themes in the metadata file. For example, you might have decided your WP theme is geophysics, but a dataset is also related to geodesy. Again, please check that this term is in the FAST vocabulary.
 - if there is likely to be more than 1 way that the data could be made available (e.g. netCDF and csv)

## Why do I need to use a controlled vocabulary?

Using a standard vocabulary (such as the FAST Vocabulary)  has many benefits:
 -  the terms are managed by an external body
 -  the hierarchy has been agreed (e.g. you will see for that for geophysics, it has "skos broader" topics of "physics" and "earth sciences", which I hope you agree with! Don't worry what "skos" means)
 -  using controlled vocabularies means that everybody who uses it knows they are using the same definitions as everybody else using it
 -  the vocabulary is updated at given intervals

All of these advantages mean that we, as a project, don't need to think about this - there is no need to reinvent the wheel when other institutes (e.g. National Libraries) have created. You might recognise WorldCat - it is an organisation which manages a global catalogue of ~18000 libraries world-wide, so they are in a good position to generate a comprehensive vocabulary of academic topics!

## What about licensing? (What does CC-BY-SA 4.0 mean?)

The R in FAIR stands for reusable - more specifically it includes this subphrase: "(Meta)data are released with a clear and accessible data usage license". This means that we have to tell anyone else who uses the data what they're allowed to do with it - and, under the FAIR philosophy, more freedom is better.  

CC-BY-SA 4.0 allows anyone to remix, adapt, and build upon your work (even for commercial purposes), as long as they credit you and license their new creations under the identical terms. It also explicitly includes Sui Generis Database Rights, giving rights to the curation of a database even if you don't have the rights to the items in a database (e.g. a Spotify playlist, even though you don't own the rights to each track).

Human readable summary: https://creativecommons.org/licenses/by-sa/4.0/ 
Full legal code: https://creativecommons.org/licenses/by-sa/4.0/legalcode

## I'm stuck! How do I get help?

Contact Chris Wood via eidf@epcc.ed.ac.uk or +44(0)131 651 3550 (during COVID-19 this number is redirected to his mobile)

