# EIDF Service Status

The table below represents the broad status of each EIDF service.

<div style="display: flex;">
<iframe src="https://status.eidf.ac.uk/d-solo/a4819422-0c95-4d9c-a5a4-7f1c2dcfd817/eidf-status-public?orgId=5&panelId=1" width="100%" height="270" frameborder="0"></iframe>
</div>

| Service | Status |
|:--------|:------|
| EIDF Portal  | ![Custom badge](https://img.shields.io/endpoint?style=plastic&url=https://epcced.github.io/eidf-status/Data/portal.json) |
| VM SSH Gateway  | ![Custom badge](https://img.shields.io/endpoint?style=plastic&url=https://epcced.github.io/eidf-status/Data/sshgateway.json) |
| VM VDI Gateway | ![Custom badge](https://img.shields.io/endpoint?style=plastic&url=https://epcced.github.io/eidf-status/Data/vdigateway.json) |
| Virtual Desktops | ![Custom badge](https://img.shields.io/endpoint?style=plastic&url=https://epcced.github.io/eidf-status/Data/virtualmachines.json) |
| Ultra2 | ![Custom badge](https://img.shields.io/endpoint?style=plastic&url=https://epcced.github.io/eidf-status/Data/superdome.json) |

## Advanced Computing Facility (ACF) Power Outage: Friday 29th August - Monday 15th September

Due to a significant Health and Safety risk, associated with our power supply to the site, that requires action at the ACF, there will be a full power outage to the site from Friday 29th August - Monday 15th September.  Specialised external contractors will be working on a 24/7 basis for the outage period replacing switchgear. The EIDF Services are hosted at the ACF.

### EIDF User Impact

The EIDF Services will be completely powered off for the duration of this period.

The EIDF Services impacted are:

* EIDF Cerebras Service
* EIDF Data Catalogue
* EIDF Data Publishing Service
* EIDF GPU Service
* EIDF Jupyter Notebook
* EIDF Portal
* EIDF S3 Service
* EIDF Ultra2 Service
* EIDF Virtual Desktops

Users will not be able to connect to any of the EIDF Services. Data will be stored safely but users will not be able to access data during the work.  Where appropriate, services will be drained of jobs ahead of the power outage and jobs will not run during this period. Any queued jobs will remain in the queue during the outage and jobs will start once the service is returned.

The EIDF website will be available during the outage period and updates will be provided during the outage at [https://docs.eidf.ac.uk/status/](https://docs.eidf.ac.uk/status/).

The site will be handed back to EPCC on Monday 15th September and we will work to return services thereafter. We will notify users once services are available.

We apologise for the inconvenience of this essential outage. Please contact [eidf@epcc.ed.ac.uk](mailto:eidf@epcc.ed.ac.uk) if you have any questions.

## Maintenance Sessions

There will be a service outage on the 3rd Thursday of every month from 9am to 5pm. We keep maintenance downtime to a minimum on the service but do occasionally need to perform essential work on the system. Maintenance sessions are used to ensure that:

* software versions are kept up to date;
* firmware levels on the underlying hardware are kept up to date;
* essential security patches are applied;
* failed/suspect hardware can be replaced;
* new software can be installed; periodic essential maintenance on electrical and mechanical support equipment (cooling systems and power distribution units) can be undertaken safely.

The service will be returned to service ahead of 5pm if all the work is completed early.
