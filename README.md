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
