# stysyphus

## Metadata schema

```typescript
interface Metadata = {
    title: string;
    abstract: string;
    keywords: string[];
    authors: {
        fullname: string;
        corresponding?: boolean;
        affiliation?: {
            organization: string,
            address?: {
                addressline?: string;
                city?: string;
                postcode?: string;
                country?: string;
            }
        };
        email?: string[];
        orcid?: string;
        funding?: {
            fundingBody: string;
            grantNumber: string;
        }[];
        acknowledgements?: string;
    }[];
}
```

## Target CLSs

- [ ] `article`
- [ ] `scrartcl`
- [ ] `amsart`
- [ ] `elsarticle`
- [ ] `tac`
- [ ] `svjour`
- [ ] `eptcs`
- [ ] `lipics-v2021`
- [ ] `IEEEtran`
- [ ] ...
